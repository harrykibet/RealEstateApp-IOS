import Foundation

public final class OfflineDownloadController : Sendable {
    public init() {}

    public func scheduleDownload(mediaId: String, source: MediaSource) {
        // Minimal stub — integrate with URLSession background tasks or specialized cache
        print("[OfflineDownloadController] scheduleDownload: \(mediaId)")
    }
}
