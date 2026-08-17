import Foundation

public struct ManagedPlayer {
    public let mediaId: String
    public let engine: PlayerEngine
    public var pinned: Bool = false
    public var lastUsed: Date = Date()

    public init(mediaId: String, engine: PlayerEngine) {
        self.mediaId = mediaId
        self.engine = engine
    }
}
