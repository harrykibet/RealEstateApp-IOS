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
    private let cdnSelector: CdnSelector?

    public init(cdns: [Cdn] = [], cacheWarmer: CacheWarmer = CacheWarmer(), offlineController: OfflineDownloadController = OfflineDownloadController(), measurer: LatencyMeasurer = DefaultLatencyMeasurer()) {
        self.cacheWarmer = cacheWarmer
        self.offlineController = offlineController
        self.cdnSelector = cdns.isEmpty ? nil : CdnSelector(cdns: cdns, measurer: measurer)
    }

    public func warm(mediaId: String, source: MediaSource, priority: WarmPriority) async {
        Task.detached {
            // If CDN selection is configured, try to resolve the best CDN then warm that endpoint.
            if let selector = self.cdnSelector {
                if let best = await selector.selectBestCdn(forPath: source.url.path) {
                    let resolved = best.resolve(path: source.url.absoluteString)
                    let replacementSource = MediaSource(url: resolved, type: source.type, headers: source.headers, metadata: source.metadata)
                    await self.cacheWarmer.warm(mediaId: mediaId, source: replacementSource, priority: priority)
                } else {
                    await self.cacheWarmer.warm(mediaId: mediaId, source: source, priority: priority)
                }
            } else {
                await self.cacheWarmer.warm(mediaId: mediaId, source: source, priority: priority)
            }
        }
    }
}
