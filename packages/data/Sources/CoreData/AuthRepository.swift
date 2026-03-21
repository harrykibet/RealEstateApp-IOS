import Foundation
import model
import network

public protocol AuthRepository: Repository {
    func signIn(email: String, password: String) async throws -> User
    func signUp(email: String, password: String, displayName: String?) async throws -> User
    func signOut() async throws
    func currentUser() async throws -> User?
}

public final class RemoteAuthRepository: AuthRepository {
    private let remote: AuthRemoteDataSource

    public init(remote: AuthRemoteDataSource) {
        self.remote = remote
    }

    public func signIn(email: String, password: String) async throws -> User {
        try await remote.signIn(email: email, password: password)
    }

    public func signUp(email: String, password: String, displayName: String?) async throws -> User {
        try await remote.signUp(email: email, password: password, displayName: displayName)
    }

    public func signOut() async throws {
        try await remote.signOut()
    }

    public func currentUser() async throws -> User? {
        try await remote.currentUser()
    }
}
