import Foundation
import CoreModel
import CoreNetwork

public protocol AuthRepository: Repository {
    func signIn(
        email: String,
        password: String
    ) async throws -> AuthenticationResult
    
    func signUp(
        email: String,
        password: String,
        displayName: String?
    ) async throws -> AuthenticationResult
    
    func signOut() async throws
    
    func currentAuthenticationState()
    async throws -> AuthenticationState
}

public final class RemoteAuthRepository: AuthRepository {
    private let remote: AuthRemoteDataSource
    
    public init(remote: AuthRemoteDataSource) {
        self.remote = remote
    }
    
    public func signIn(email: String, password: String) async throws -> AuthenticationResult {
        try await remote.signIn(email: email, password: password)
    }
    
    public func signUp(email: String, password: String, displayName: String?) async throws -> AuthenticationResult {
        try await remote.signUp(email: email, password: password, displayName: displayName)
    }
    
    public func signOut() async throws {
        try await remote.signOut()
    }
    
    public func currentUser() async throws -> User? {
        try await remote.currentUser()
    }
    
    func currentAuthenticationState()
    async throws -> AuthenticationState {
        try await remote.currentAuthenticationState()
    }
}
