import Foundation
import MediaPlayer

public final class MediaSessionProvider {
    public init() {}

    /// Configure now playing metadata for a given engine's current item.
    /// Minimal implementation — can be extended to subscribe to engine events.
    public func configureNowPlaying(title: String?, artist: String?) {
        var nowPlaying: [String: Any] = [:]
        if let title { nowPlaying[MPMediaItemPropertyTitle] = title }
        if let artist { nowPlaying[MPMediaItemPropertyArtist] = artist }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlaying
    }
}
