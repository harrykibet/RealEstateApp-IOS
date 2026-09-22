import Foundation

@MainActor
public final class ManagedPlayer {

    public let engine: PlayerEngine

    public private(set) var mediaId: String?

    public private(set) var pinned: Bool

    /// Monotonic logical access sequence used for deterministic LRU eviction.
    public private(set) var lastUsedSequence: UInt64

    internal init(
        engine: PlayerEngine,
        mediaId: String? = nil
    ) {
        self.engine = engine
        self.mediaId = mediaId
        self.pinned = false
        self.lastUsedSequence = 0
    }

    /// Retained for source compatibility with callers that explicitly construct
    /// a managed player. Normal application code should obtain instances from
    /// PlayerPool.
    internal convenience init(
        mediaId: String,
        engine: PlayerEngine
    ) {
        self.init(
            engine: engine,
            mediaId: mediaId
        )
    }

    internal func activate(
        mediaId: String,
        sequence: UInt64,
        pinned: Bool
    ) {
        self.mediaId = mediaId
        self.lastUsedSequence = sequence
        self.pinned = pinned
    }

    internal func touch(sequence: UInt64) {
        self.lastUsedSequence = sequence
    }

    internal func markPinned(_ pinned: Bool) {
        self.pinned = pinned
    }

    internal func markIdle() {
        self.mediaId = nil
        self.pinned = false
        self.lastUsedSequence = 0
    }
}
