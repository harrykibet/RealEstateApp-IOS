import Foundation

public final class CdnSelector: @unchecked Sendable {
    private let cdns: [Cdn]
    private let measurer: LatencyMeasurer

    public init(cdns: [Cdn], measurer: LatencyMeasurer = DefaultLatencyMeasurer()) {
        self.cdns = cdns
        self.measurer = measurer
    }

    /// Choose the lowest-latency healthy CDN for the given path.
    public func selectBestCdn(forPath path: String) async -> Cdn? {
        guard !cdns.isEmpty else { return nil }

        var latencies: [(Cdn, TimeInterval?)] = []
        await withTaskGroup(of: (Cdn, TimeInterval?).self) { group in
            for cdn in cdns {
                let meas = self.measurer
                group.addTask {
                    if let check = cdn.healthCheckPath, let url = URL(string: check, relativeTo: cdn.baseURL) {
                        let ms = await meas.measure(url: url)
                        return (cdn, ms)
                    } else {
                        // No health check path; measure base URL
                        let ms = await meas.measure(url: cdn.baseURL)
                        return (cdn, ms)
                    }
                }
            }

            for await result in group {
                latencies.append(result)
            }
        }

        // Filter out nils (unreachable) and pick smallest latency
        let healthy = latencies.compactMap { (cdn, latency) -> (Cdn, TimeInterval)? in
            guard let l = latency else { return nil }
            return (cdn, l)
        }

        return healthy.sorted { $0.1 < $1.1 }.first?.0
    }
}
