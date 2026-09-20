import Foundation

#if canImport(AVFoundation) && os(iOS)
import AVFoundation
#endif

public final class AudioSessionManager {
    public init() {}

    public func request() {
        #if canImport(AVFoundation) && os(iOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Best-effort; swallow but could surface via metrics
            print("[AudioSessionManager] request failed: \(error)")
        }
        #else
        // No-op on platforms without AVAudioSession
        #endif
    }

    public func abandon() {
        #if canImport(AVFoundation) && os(iOS)
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("[AudioSessionManager] abandon failed: \(error)")
        }
        #else
        // No-op
        #endif
    }

    public func cleanup() {
        abandon()
    }
}
