import Foundation
import AVFoundation

public final class AudioSessionManager {
    public init() {}

    public func request() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Best-effort; swallow but could surface via metrics
            print("[AudioSessionManager] request failed: \(error)")
        }
    }

    public func abandon() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("[AudioSessionManager] abandon failed: \(error)")
        }
    }

    public func cleanup() {
        abandon()
    }
}
