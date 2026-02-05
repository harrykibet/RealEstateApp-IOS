import Foundation
import model
import network

public protocol SecurityRepository: Repository {
    func fetchSecurityConfig() async throws -> SecurityConfig
    func updateSecurityConfig(_ config: SecurityConfig) async throws -> SecurityConfig
}

public final class RemoteSecurityRepository: SecurityRepository {
    private let remote: SecurityRemoteDataSource

    public init(remote: SecurityRemoteDataSource) {
        self.remote = remote
    }

    public func fetchSecurityConfig() async throws -> SecurityConfig {
        try await remote.fetchSecurityConfig()
    }

    public func updateSecurityConfig(_ config: SecurityConfig) async throws -> SecurityConfig {
        try await remote.updateSecurityConfig(config)
    }
}
