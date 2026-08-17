import Foundation

/// Actor-based pool managing multiple PlayerEngine instances keyed by mediaId.
public actor PlayerPool {
    private var pool: [String: ManagedPlayer] = [:]

    public init() {}

    /// Get an existing engine for mediaId or create a new one using PlayerEngineFactory.
    /// If `loadSource` is true the engine will be loaded (prewarm/load) with the provided source.
    public func getOrCreate(mediaId: String, source: MediaSource, loadSource: Bool = false) async throws -> ManagedPlayer {
        if var existing = pool[mediaId] {
            existing.lastUsed = Date()
            pool[mediaId] = existing
            return existing
        }

        let engine = await MainActor.run { PlayerEngineFactory.make() }
        let managed = ManagedPlayer(mediaId: mediaId, engine: engine)
        pool[mediaId] = managed

        if loadSource {
            try await engine.load(source)
        }

        return managed
    }

    public func get(mediaId: String) -> ManagedPlayer? {
        pool[mediaId]
    }

    public func prewarm(mediaId: String, source: MediaSource) async -> Bool {
        do {
            _ = try await getOrCreate(mediaId: mediaId, source: source, loadSource: true)
            return true
        } catch {
            return false
        }
    }

    public func release(mediaId: String) {
        if let managed = pool.removeValue(forKey: mediaId) {
            managed.engine.release()
        }
    }

    public func releaseAll() {
        for (_, managed) in pool {
            managed.engine.release()
        }
        pool.removeAll()
    }

    public func forEach(_ body: (ManagedPlayer) -> Void) {
        for (_, managed) in pool {
            body(managed)
        }
    }

    public func updatePinnedIds(_ pinned: Set<String>) {
        for key in pool.keys {
            var m = pool[key]!
            m.pinned = pinned.contains(key)
            pool[key] = m
        }
    }
}
