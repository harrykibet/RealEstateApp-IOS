import Foundation
import CoreModel

public protocol SecurityRemoteDataSource: Sendable {
    func fetchSecurityConfig() async throws -> SecurityConfig
    func updateSecurityConfig(_ config: SecurityConfig) async throws -> SecurityConfig
}

public final class NoopSecurityRemoteDataSource: SecurityRemoteDataSource {
    public init() {}

    public func fetchSecurityConfig() async throws -> SecurityConfig {
        SecurityConfig(encryptionAlgorithm: "noop", keyAlias: "noop")
    }

    public func updateSecurityConfig(_ config: SecurityConfig) async throws -> SecurityConfig {
        config
    }
}
