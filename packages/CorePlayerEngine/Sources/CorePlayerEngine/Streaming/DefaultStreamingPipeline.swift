import Foundation

@available(iOS 18.0, macOS 10.15, *)
public final class DefaultStreamingPipeline:
    StreamingPipeline,
    Sendable {

    private let cacheWarmer:
        MediaCacheWarmer

    private let offlineController:
        OfflineDownloadController

    private let cdnSelector:
        CdnSelector?

    private let cacheKeyFactory:
        MediaCacheKeyProviding

    public init(
        cdns: [Cdn] = [],
        cacheWarmer:
            MediaCacheWarmer,
        offlineController:
            OfflineDownloadController =
            OfflineDownloadController(),
        measurer:
            LatencyMeasurer =
            DefaultLatencyMeasurer(),
        cacheKeyFactory:
            MediaCacheKeyProviding =
            DefaultMediaCacheKeyFactory()
    ) {
        self.cacheWarmer =
            cacheWarmer

        self.offlineController =
            offlineController

        self.cdnSelector =
            cdns.isEmpty
            ? nil
            : CdnSelector(
                cdns: cdns,
                measurer: measurer
            )

        self.cacheKeyFactory =
            cacheKeyFactory
    }

    public func warm(
        mediaId: String,
        source: MediaSource,
        priority: WarmPriority
    ) async {

        guard !Task.isCancelled else {
            return
        }

        // IMPORTANT:
        // Compute the cache identity from the logical/original source,
        // not the CDN-resolved URL. Otherwise every CDN creates a distinct
        // local cache namespace for the same logical media.
        let cacheKey =
            cacheKeyFactory.makeKey(
                mediaId:
                    mediaId,
                source:
                    source
            )

        var networkSource =
            source

        if let selector =
            cdnSelector,
           let best =
            await selector.selectBestCdn(
                forPath:
                    source.url.path
            ) {

            let base =
                best.baseURL
                    .absoluteString

            let path =
                source.url.path

            let resolvedString:

                String =
                base.hasSuffix("/")
                ? String(
                    base.dropLast()
                ) + path
                : base + path

            if let resolved =
                URL(
                    string:
                        resolvedString
                ) {

                networkSource =
                    MediaSource(
                        url:
                            resolved,
                        type:
                            source.type,
                        headers:
                            source.headers,
                        metadata:
                            source.metadata
                    )
            }
        }

        _ = await cacheWarmer.warm(
            MediaCacheWarmRequest(
                mediaId:
                    mediaId,
                source:
                    networkSource,
                cacheKey:
                    cacheKey,
                priority:
                    priority
            )
        )
    }
}
