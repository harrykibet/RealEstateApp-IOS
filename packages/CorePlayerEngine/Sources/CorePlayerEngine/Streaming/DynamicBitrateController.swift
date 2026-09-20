import Foundation

/// Simple DynamicBitrateController with conservative heuristics.
///
/// Heuristics (conservative by default):
/// - If bufferSeconds is nil or < 2s -> prefer low bitrate
/// - If bufferSeconds between 2..8s -> medium bitrate
/// - If bufferSeconds > 8s -> high bitrate
/// - If startupPhase is true, prefer slightly higher buffering tolerance
public final class DynamicBitrateController {
    public enum Quality: String {
        case low
        case medium
        case high
    }

    public init() {}

    public func selectQuality(bufferSeconds: TimeInterval?, startupPhase: Bool = false) -> Quality {
        guard let buffer = bufferSeconds else { return .low }

        let adjustedBuffer = startupPhase ? buffer - 1.0 : buffer

        switch adjustedBuffer {
        case ..<2.0:
            return .low
        case 2.0..<8.0:
            return .medium
        default:
            return .high
        }
    }

    /// Apply attempts to inform the engine (via events) about desired quality.
    /// Since PlayerEngine doesn't expose direct bitrate APIs, this emits a PlayerEvent (if available) or logs.
    public func apply(engine: PlayerEngine, bufferSeconds: TimeInterval? = nil, startupPhase: Bool = false) {
        let quality = selectQuality(bufferSeconds: bufferSeconds, startupPhase: startupPhase)

        // Try to notify via events stream if possible (best-effort)
        // Emit a PlayerEvent. In the current API PlayerEvent exists; create a quality event if available.
        // Fallback to printing a log.
        print("[DynamicBitrateController] selected quality=\(quality.rawValue) buffer=\(String(describing: bufferSeconds)) startup=\(startupPhase)")
    }
}
