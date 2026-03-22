import Foundation
import CoreModel

public final class SecurityRestRemoteDataSource: SecurityRemoteDataSource {
    private let client: APIClient
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    public init(client: APIClient, decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder()) {
        self.client = client
        self.decoder = decoder
        self.encoder = encoder
    }

    public func fetchSecurityConfig() async throws -> SecurityConfig {
        let data = try await client.get("/security/config")
        return try decoder.decode(SecurityConfig.self, from: data)
    }

    public func updateSecurityConfig(_ config: SecurityConfig) async throws -> SecurityConfig {
        let data = try await client.put("/security/config", body: try encoder.encode(config))
        return try decoder.decode(SecurityConfig.self, from: data)
    }
}
