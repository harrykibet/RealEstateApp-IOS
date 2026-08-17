import Foundation

public protocol LatencyMeasurer {
    func measure(url: URL) async -> TimeInterval?
}

public final class DefaultLatencyMeasurer: LatencyMeasurer {
    private let session: URLSession

    public init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }

    public func measure(url: URL) async -> TimeInterval? {
        var req = URLRequest(url: url)
        req.httpMethod = "HEAD"
        req.timeoutInterval = 3.0

        let start = Date()
        do {
            let (_, response) = try await session.data(for: req)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
            return Date().timeIntervalSince(start)
        } catch {
            return nil
        }
    }
}
