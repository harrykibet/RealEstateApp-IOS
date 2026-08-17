import Foundation

public enum WarmPriority: Int {
    case background = 0
    case visible = 1
}

public protocol StreamingPipeline {
    func warm(mediaId: String, source: MediaSource, priority: WarmPriority) async
}

public final class DefaultStreamingPipeline: StreamingPipeline {
    private let cacheWarmer: CacheWarmer
    private let offlineController: OfflineDownloadController

    public init(cacheWarmer: CacheWarmer = CacheWarmer(), offlineController: OfflineDownloadController = OfflineDownloadController()) {
        self.cacheWarmer = cacheWarmer
        self.offlineController = offlineController
    }

    public func warm(mediaId: String, source: MediaSource, priority: WarmPriority) async {
        // Minimal implementation: fire-and-forget warm
        Task.detached {
            await self.cacheWarmer.warm(mediaId: mediaId, source: source, priority: priority)
        }
    }
}
