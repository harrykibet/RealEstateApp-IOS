import Foundation
import CoreModel

public protocol AuthRemoteDataSource: Sendable {

    func signIn(
        email: String,
        password: String
    ) async throws -> AuthSession

    func signUp(
        email: String,
        password: String,
        displayName: String?
    ) async throws -> AuthSession

    func signOut() async throws

    func currentSession() async throws -> AuthSession
}
