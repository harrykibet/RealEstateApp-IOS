import Foundation
import CoreModel

public protocol AuthRemoteDataSource {
    
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
