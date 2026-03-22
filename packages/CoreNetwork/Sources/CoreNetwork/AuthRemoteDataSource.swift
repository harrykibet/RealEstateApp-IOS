import Foundation
import CoreModel

public protocol AuthRemoteDataSource {
    func signIn(email: String, password: String) async throws -> User
    func signUp(email: String, password: String, displayName: String?) async throws -> User
    func signOut() async throws
    func currentUser() async throws -> User?
}

public final class NoopAuthRemoteDataSource: AuthRemoteDataSource {
    public init() {}

    public func signIn(email: String, password: String) async throws -> User {
        User(name: nil, email: email)
    }

    public func signUp(email: String, password: String, displayName: String?) async throws -> User {
        User(name: displayName, email: email)
    }

    public func signOut() async throws {}

    public func currentUser() async throws -> User? {
        nil
    }
}
