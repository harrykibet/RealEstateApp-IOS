import Foundation

public struct Cdn {
    public let id: String
    public let baseURL: URL
    public let healthCheckPath: String?

    public init(id: String, baseURL: URL, healthCheckPath: String? = nil) {
        self.id = id
        self.baseURL = baseURL
        self.healthCheckPath = healthCheckPath
    }

    public func resolve(path: String) -> URL {
        return URL(string: path, relativeTo: baseURL) ?? baseURL
    }
}
