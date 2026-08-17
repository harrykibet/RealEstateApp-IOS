import Foundation

public final class CacheWarmer {
    public init() {}

    public func warm(mediaId: String, source: MediaSource, priority: WarmPriority) async {
        // Basic no-op implementation. Real implementation would read the URL and prefetch chunks into a cache.
        // Keep this non-blocking.
        print("[CacheWarmer] warm \(mediaId) priority=\(priority)")
    }
}
