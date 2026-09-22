import Foundation

public enum PlayerPoolError: Error, Equatable, LocalizedError {
    case capacityExceeded

    public var errorDescription: String? {
        switch self {
        case .capacityExceeded:
            return "The player pool has reached capacity and all active players are pinned."
        }
    }
}

///
/// Bounded lifecycle manager for PlayerEngine instances.
///
/// Ownership contract:
/// - Pool owns every retained PlayerEngine.
/// - All pool state is main-actor isolated.
/// - Mutating operations are serialized across suspension points.
/// - Active players are indexed by media ID.
/// - Released players may be retained in an idle reservoir.
/// - Idle players are reused before allocating new player instances.
/// - Pinned players are never evicted.
/// - When capacity is reached, the least-recently-used unpinned player
///   is recycled.
///
@MainActor
public final class PlayerPool {

    // MARK: - Internal Gate

    /// MainActor isolation alone does not prevent actor reentrancy across
    /// `await` points. This gate serializes logical pool mutations so that
    /// release/reuse/eviction operations cannot interleave halfway through
    /// a lifecycle transition.
    private actor MutationGate {

        private var locked = false

        private var waiters: [
            CheckedContinuation<Void, Never>
        ] = []

        func lock() async {
            guard locked else {
                locked = true
                return
            }

            await withCheckedContinuation { continuation in
                waiters.append(continuation)
            }
        }

        func unlock() {
            guard let continuation = waiters.first else {
                locked = false
                return
            }

            waiters.removeFirst()
            continuation.resume()
        }
    }

    // MARK: - Dependencies

    private let configuration: PlayerPoolConfiguration

    private let makeEngine: @MainActor () -> PlayerEngine

    private let mutationGate = MutationGate()

    // MARK: - State

    private var activePlayers: [String: ManagedPlayer] = [:]

    private var idlePlayers: [ManagedPlayer] = []

    private var allPlayers: [ManagedPlayer] = []

    private var pinnedMediaIds: Set<String> = []

    private var accessSequence: UInt64 = 0

    // MARK: - Init

    public init(
        configuration: PlayerPoolConfiguration = PlayerPoolConfiguration(),
        factory: @escaping @MainActor () -> PlayerEngine = {
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

        await mutationGate.lock()

        let result = activePlayers[mediaId]

        if let result {
            touch(result)
        }

        await mutationGate.unlock()

        return result
    }
    
    // MARK: - Acquisition

    /// Returns an existing player or creates/reuses one.
    ///
    /// A source is always loaded for a newly allocated or recycled player.
    /// Existing active media is returned without reloading.
    public func getOrCreate(
        mediaId: String,
        source: MediaSource
    ) async throws -> ManagedPlayer {

        await mutationGate.lock()

        do {
            if let existing = activePlayers[mediaId] {
                touch(existing)

                await mutationGate.unlock()

                return existing
            }

            let managed = try await acquirePlayer()

            activate(
                managed,
                mediaId: mediaId
            )

            do {
                try await managed.engine.load(source)
            } catch {
                activePlayers.removeValue(
                    forKey: mediaId
                )

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

                // IMPORTANT:
                // Do not unlock here.
                //
                // The outer catch owns the gate release.
                throw error
            }

            await mutationGate.unlock()

            return managed

        } catch {
            await mutationGate.unlock()
            throw error
        }
    }
    
    // MARK: - Prewarm

    /// Prepares a player for a media item without starting playback.
    ///
    /// The player remains active in the pool because later playback can reuse
    /// the prepared engine without another allocation.
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

    /// Releases an active media binding.
    ///
    /// The underlying PlayerEngine is retained when idle capacity is available,
    /// otherwise it is fully released.
    public func release(
        mediaId: String
    ) async {

        await mutationGate.lock()

        guard let managed = activePlayers[mediaId] else {
            await mutationGate.unlock()
            return
        }

        do {
            try await managed.engine.stop()
        } catch {
            // Stop failure must not leak the hardware player.
            try? await managed.engine.release()
            activePlayers.removeValue(forKey: mediaId)
            managed.markIdle()
            removeFromPool(managed)

            await mutationGate.unlock()
            return
        }

        activePlayers.removeValue(forKey: mediaId)

        managed.markIdle()

        if idlePlayers.count < configuration.maxIdlePlayers {
            idlePlayers.append(managed)
        } else {
            try? await managed.engine.release()
            removeFromPool(managed)
        }

        await mutationGate.unlock()
    }

    // MARK: - Release All

    public func releaseAll() async {

        await mutationGate.lock()

        let players = allPlayers

        activePlayers.removeAll(keepingCapacity: true)
        idlePlayers.removeAll(keepingCapacity: true)
        allPlayers.removeAll(keepingCapacity: true)
        pinnedMediaIds.removeAll(keepingCapacity: true)

        await withTaskGroup(of: Void.self) { group in
            for managed in players {
                group.addTask { @MainActor in
                    try? await managed.engine.release()
                    managed.markIdle()
                }
            }
        }

        await mutationGate.unlock()
    }

    // MARK: - Pinning

    public func updatePinnedIds(
        _ pinned: Set<String>
    ) async {

        await mutationGate.lock()

        pinnedMediaIds = pinned

        for managed in activePlayers.values {
            managed.markPinned(
                pinned.contains(managed.mediaId ?? "")
            )
        }

        await mutationGate.unlock()
    }

    // MARK: - Iteration

    public func activePlayersSnapshot() async -> [ManagedPlayer] {

        await mutationGate.lock()

        let snapshot = Array(activePlayers.values)

        await mutationGate.unlock()

        return snapshot
    }

    // MARK: - Capacity

    private func acquirePlayer() async throws -> ManagedPlayer {

        // 1. Always prefer an idle retained player.
        if let idle = idlePlayers.popLast() {
            return idle
        }

        // 2. Allocate when capacity exists.
        if allPlayers.count < configuration.maxPlayers {
            let managed = ManagedPlayer(
                engine: makeEngine()
            )

            allPlayers.append(managed)

            return managed
        }

        // 3. Pool is full; recycle the least recently used unpinned player.
        guard let evictable = leastRecentlyUsedEvictablePlayer() else {
            throw PlayerPoolError.capacityExceeded
        }

        guard let mediaId = evictable.mediaId else {
            removeFromPool(evictable)
            return try await acquirePlayer()
        }

        activePlayers.removeValue(forKey: mediaId)

        // The player is no longer bound to its old media item.
        do {
            try await evictable.engine.stop()
        } catch {
            try? await evictable.engine.release()
            removeFromPool(evictable)

            // We now have capacity for a new player.
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
            pinned: pinnedMediaIds.contains(mediaId)
        )

        activePlayers[mediaId] = managed
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

    private func leastRecentlyUsedEvictablePlayer()
        -> ManagedPlayer?
    {
        activePlayers.values
            .filter { !$0.pinned }
            .min {
                $0.lastUsedSequence < $1.lastUsedSequence
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

    public var maxPlayers: Int {
        configuration.maxPlayers
    }

    public func contains(
        mediaId: String
    ) async -> Bool {
        await get(mediaId: mediaId) != nil
    }

    public func hasDuplicateInstances() -> Bool {

        let identifiers = allPlayers.map {
            ObjectIdentifier($0.engine)
        }

        return Set(identifiers).count != identifiers.count
    }
}
