import Foundation

public enum PlayerPoolError:
    Error,
    Equatable,
    LocalizedError {

    case capacityExceeded
    case draining

    public var errorDescription: String? {

        switch self {

        case .capacityExceeded:
            return """
            The player pool has reached capacity and all active players \
            are pinned.
            """

        case .draining:
            return """
            The player pool is currently releasing its resources and \
            cannot accept new players.
            """
        }
    }
}

@MainActor
public final class PlayerPool {

    // MARK: - Dependencies

    private let configuration:
        PlayerPoolConfiguration

    private let makeEngine:
        @MainActor () -> PlayerEngine

    // MARK: - State

    private var activePlayers:
        [String: ManagedPlayer] = [:]

    private var idlePlayers:
        [ManagedPlayer] = []

    private var allPlayers:
        [ManagedPlayer] = []

    private var pinnedMediaIds:
        Set<String> = []

    private var accessSequence:
        UInt64 = 0

    // MARK: - In-Flight Creation

    /// One creation task per media ID.
    ///
    /// This prevents:
    ///
    ///     request A ──┐
    ///                  ├── create two players
    ///     request A ──┘
    ///
    /// from occurring concurrently.
    ///
    /// Unrelated media IDs may still be created concurrently.
    private var inFlightCreations:
        [String: Task<ManagedPlayer, Error>] = [:]

    // MARK: - Lifecycle

    private var isDraining = false

    // MARK: - Initialization

    public init(
        configuration:
            PlayerPoolConfiguration =
            PlayerPoolConfiguration(),

        factory: @escaping @MainActor () -> PlayerEngine =
            {
                PlayerEngineFactory.make()
            }
    ) {
        self.configuration = configuration
        self.makeEngine = factory
    }

    // MARK: - Lookup

    public func get(
        mediaId: String
    ) async -> ManagedPlayer? {

        guard !isDraining else {
            return nil
        }

        guard let managed =
                activePlayers[mediaId]
        else {
            return nil
        }

        touch(
            managed
        )

        return managed
    }

    // MARK: - Acquisition

    public func getOrCreate(
        mediaId: String,
        source: MediaSource
    ) async throws -> ManagedPlayer {

        guard !isDraining else {
            throw PlayerPoolError.draining
        }

        // IMPORTANT:
        // Check in-flight creation before active state.
        //
        // A creation task may have reserved this media ID while
        // the actual AVPlayer load is suspended.
        if let inFlight =
            inFlightCreations[mediaId] {

            return try await inFlight.value
        }

        if let existing =
            activePlayers[mediaId] {

            touch(
                existing
            )

            return existing
        }

        let creation =
            Task<ManagedPlayer, Error> { @MainActor [self] in

                try await createAndLoad(
                    mediaId: mediaId,
                    source: source
                )
            }

        inFlightCreations[mediaId] =
            creation

        return try await creation.value
    }

    // MARK: - Creation

    private func createAndLoad(
        mediaId: String,
        source: MediaSource
    ) async throws -> ManagedPlayer {

        defer {
            inFlightCreations.removeValue(
                forKey: mediaId
            )
        }

        let managed =
            try await acquirePlayer()

        do {

            try Task.checkCancellation()

            try await managed.engine.load(
                source
            )

            try Task.checkCancellation()

        } catch {

            // The engine must be returned to a known lifecycle state
            // before it can be reused or discarded.
            try? await managed.engine.release()

            managed.markIdle()

            if idlePlayers.count <
                configuration.maxIdlePlayers {

                idlePlayers.append(
                    managed
                )

            } else {

                removeFromPool(
                    managed
                )
            }

            throw error
        }

        activate(
            managed,
            mediaId: mediaId
        )

        return managed
    }

    // MARK: - Prewarm

    public func prewarm(
        mediaId: String,
        source: MediaSource
    ) async -> Bool {

        do {

            _ = try await getOrCreate(
                mediaId: mediaId,
                source: source
            )

            return true

        } catch {

            return false
        }
    }

    // MARK: - Release

    public func release(
        mediaId: String
    ) async {

        guard !isDraining else {
            return
        }

        guard let managed =
                activePlayers.removeValue(
                    forKey: mediaId
                )
        else {
            return
        }

        do {

            try await managed.engine.stop()

        } catch {

            try? await managed.engine.release()

            managed.markIdle()

            removeFromPool(
                managed
            )

            return
        }

        managed.markIdle()

        if idlePlayers.count <
            configuration.maxIdlePlayers {

            idlePlayers.append(
                managed
            )

        } else {

            try? await managed.engine.release()

            removeFromPool(
                managed
            )
        }
    }

    // MARK: - Release All

    public func releaseAll() async {

        guard !isDraining else {
            return
        }

        isDraining = true

        // First stop creation of new resources.
        //
        // getOrCreate() will now fail with `.draining`.
        //
        // Existing in-flight loads must be cancelled and awaited before
        // hardware resources are finally released.
        let pendingCreations =
            Array(
                inFlightCreations.values
            )

        for task in pendingCreations {
            task.cancel()
        }

        for task in pendingCreations {
            _ = try? await task.value
        }

        let players =
            allPlayers

        // Remove logical ownership before suspension.
        activePlayers.removeAll(
            keepingCapacity: false
        )

        idlePlayers.removeAll(
            keepingCapacity: false
        )

        pinnedMediaIds.removeAll(
            keepingCapacity: false
        )

        // Physical resources are released only after all pending
        // creation tasks have completed.
        for managed in players {

            try? await managed.engine.release()

            managed.markIdle()
        }

        allPlayers.removeAll(
            keepingCapacity: false
        )

        inFlightCreations.removeAll(
            keepingCapacity: false
        )

        isDraining = false
    }

    // MARK: - Pinning

    public func updatePinnedIds(
        _ pinned: Set<String>
    ) async {

        guard !isDraining else {
            return
        }

        pinnedMediaIds =
            pinned

        for managed in
            activePlayers.values {

            managed.markPinned(
                pinned.contains(
                    managed.mediaId ?? ""
                )
            )
        }
    }

    // MARK: - Snapshot

    public func activePlayersSnapshot()
        async -> [ManagedPlayer] {

        guard !isDraining else {
            return []
        }

        return Array(
            activePlayers.values
        )
    }

    // MARK: - Capacity

    private func acquirePlayer()
        async throws -> ManagedPlayer {

        // 1. Reuse idle resources first.
        if let idle =
            idlePlayers.popLast() {

            return idle
        }

        // 2. Create if capacity exists.
        if allPlayers.count <
            configuration.maxPlayers {

            let managed =
                ManagedPlayer(
                    engine: makeEngine()
                )

            allPlayers.append(
                managed
            )

            return managed
        }

        // 3. Recycle least-recently-used unpinned player.
        guard let evictable =
            leastRecentlyUsedEvictablePlayer()
        else {

            throw PlayerPoolError.capacityExceeded
        }

        guard let mediaId =
                evictable.mediaId
        else {

            removeFromPool(
                evictable
            )

            return try await acquirePlayer()
        }

        activePlayers.removeValue(
            forKey: mediaId
        )

        do {

            try await evictable.engine.stop()

        } catch {

            try? await evictable.engine.release()

            removeFromPool(
                evictable
            )

            return try await acquirePlayer()
        }

        evictable.markIdle()

        return evictable
    }

    // MARK: - Activation

    private func activate(
        _ managed: ManagedPlayer,
        mediaId: String
    ) {

        accessSequence &+= 1

        managed.activate(
            mediaId: mediaId,
            sequence: accessSequence,
            pinned:
                pinnedMediaIds.contains(
                    mediaId
                )
        )

        activePlayers[mediaId] =
            managed
    }

    private func touch(
        _ managed: ManagedPlayer
    ) {

        accessSequence &+= 1

        managed.touch(
            sequence: accessSequence
        )
    }

    // MARK: - Eviction

    private func
        leastRecentlyUsedEvictablePlayer()
        -> ManagedPlayer?
    {

        activePlayers.values
            .filter {
                !$0.pinned
            }
            .min {
                $0.lastUsedSequence <
                $1.lastUsedSequence
            }
    }

    // MARK: - Pool Membership

    private func removeFromPool(
        _ managed: ManagedPlayer
    ) {

        idlePlayers.removeAll {
            $0 === managed
        }

        allPlayers.removeAll {
            $0 === managed
        }
    }

    // MARK: - Diagnostics

    public var activeCount: Int {
        activePlayers.count
    }

    public var idleCount: Int {
        idlePlayers.count
    }

    public var retainedPlayerCount: Int {
        allPlayers.count
    }

    public var inFlightCreationCount: Int {
        inFlightCreations.count
    }

    public var maxPlayers: Int {
        configuration.maxPlayers
    }

    public func contains(
        mediaId: String
    ) async -> Bool {

        await get(
            mediaId: mediaId
        ) != nil
    }

    public func hasDuplicateInstances() -> Bool {

        let identifiers =
            allPlayers.map {
                ObjectIdentifier(
                    $0.engine
                )
            }

        return Set(
            identifiers
        ).count != identifiers.count
    }
}
