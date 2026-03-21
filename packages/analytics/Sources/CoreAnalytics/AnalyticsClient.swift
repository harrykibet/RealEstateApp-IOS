import Foundation

public protocol AnalyticsClient {
    func track(name: String, properties: [String: String])
}

public final class NoopAnalyticsClient: AnalyticsClient {
    public init() {}

    public func track(name: String, properties: [String: String]) {}
}
