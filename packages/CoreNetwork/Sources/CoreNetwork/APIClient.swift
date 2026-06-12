import Foundation

public enum APIClientError: Error {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
}

public protocol APIClient: Sendable {
    func get(_ path: String, query: [URLQueryItem]?) async throws -> Data
    func post(_ path: String, body: Data?) async throws -> Data
    func put(_ path: String, body: Data?) async throws -> Data
    func delete(_ path: String) async throws -> Data
}

public extension APIClient {
    func get(_ path: String) async throws -> Data {
        try await get(path, query: nil)
    }
}

public final class NoopAPIClient: APIClient {
    public init() {}

    public func get(_ path: String, query: [URLQueryItem]?) async throws -> Data {
        Data()
    }

    public func post(_ path: String, body: Data?) async throws -> Data {
        Data()
    }

    public func put(_ path: String, body: Data?) async throws -> Data {
        Data()
    }

    public func delete(_ path: String) async throws -> Data {
        Data()
    }
}

public final class URLSessionAPIClient: APIClient {
    private let baseURL: URL
    private let session: URLSession
    private let defaultHeaders: [String: String]

    public init(
        baseURL: URL,
        session: URLSession = .shared,
        defaultHeaders: [String: String] = ["Content-Type": "application/json"]
    ) {
        self.baseURL = baseURL
        self.session = session
        self.defaultHeaders = defaultHeaders
    }

    public func get(_ path: String, query: [URLQueryItem]?) async throws -> Data {
        try await request(method: "GET", path: path, query: query, body: nil)
    }

    public func post(_ path: String, body: Data?) async throws -> Data {
        try await request(method: "POST", path: path, query: nil, body: body)
    }

    public func put(_ path: String, body: Data?) async throws -> Data {
        try await request(method: "PUT", path: path, query: nil, body: body)
    }

    public func delete(_ path: String) async throws -> Data {
        try await request(method: "DELETE", path: path, query: nil, body: nil)
    }

    private func request(
        method: String,
        path: String,
        query: [URLQueryItem]?,
        body: Data?
    ) async throws -> Data {
        let trimmedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        var url = baseURL.appendingPathComponent(trimmedPath)

        if let query, !query.isEmpty {
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw APIClientError.invalidURL
            }
            components.queryItems = query
            guard let resolved = components.url else {
                throw APIClientError.invalidURL
            }
            url = resolved
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        for (key, value) in defaultHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw APIClientError.httpStatus(http.statusCode)
        }
        return data
    }
}
