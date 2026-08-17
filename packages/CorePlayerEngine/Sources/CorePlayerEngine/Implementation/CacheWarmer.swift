import Foundation

public final class CacheWarmer {
    private let session: URLSession
    private let metrics: MetricsCollector?
    private let prefetchSize: Int = 256 * 1024 // 256 KB

    public init(session: URLSession = URLSession(configuration: .ephemeral), metrics: MetricsCollector? = nil) {
        self.session = session
        self.metrics = metrics
    }

    /// Perform a light prefetch by requesting the first N bytes of the URL using Range requests.
    /// Downloads are discarded — the intent is to warm upstream caches and CDN edges.
    public func warm(mediaId: String, source: MediaSource, priority: WarmPriority) async {
        print("[CacheWarmer] warm \(mediaId) priority=\(priority) url=\(source.url)")

        var req = URLRequest(url: source.url)
        req.httpMethod = "GET"
        req.setValue("bytes=0-\(prefetchSize - 1)", forHTTPHeaderField: "Range")
        if let headers = source.headers {
            for (k,v) in headers { req.setValue(v, forHTTPHeaderField: k) }
        }
        req.timeoutInterval = 10.0

        let start = Date()
        do {
            let (data, response) = try await session.data(for: req)
            let elapsed = Date().timeIntervalSince(start)
            let bytes = data.count
            print("[CacheWarmer] warmed \(mediaId) bytes=\(bytes) time=\(elapsed)s status=")
            if let r = response as? HTTPURLResponse {
                print(" status=\(r.statusCode)")
            }
            metrics?.onPrefetch(mediaId: mediaId, bytes: bytes, time: elapsed)
        } catch {
            print("[CacheWarmer] warm failed for \(mediaId): \(error)")
            metrics?.log("prefetch-failed \(mediaId) \(error)")
        }
    }
}
