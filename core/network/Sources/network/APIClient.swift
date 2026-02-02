import Foundation

public protocol APIClient {
    func get(_ path: String) async throws -> Data
}

public final class NoopAPIClient: APIClient {
    public init() {}

    public func get(_ path: String) async throws -> Data {
        Data()
    }
}
