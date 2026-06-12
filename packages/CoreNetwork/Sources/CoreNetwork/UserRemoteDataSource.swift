import Foundation
import CoreModel

public protocol UserRemoteDataSource: Sendable {
    func fetchUser(id: String) async throws -> User
    func updateUser(_ user: User) async throws -> User
    func deleteUser(id: String) async throws
    func fetchFavoritePropertyIds(userId: String) async throws -> [String]
    func addFavoriteProperty(userId: String, propertyId: String) async throws
    func removeFavoriteProperty(userId: String, propertyId: String) async throws
}

public final class NoopUserRemoteDataSource: UserRemoteDataSource {
    public init() {}

    public func fetchUser(id: String) async throws -> User {
        User(userId: id)
    }

    public func updateUser(_ user: User) async throws -> User {
        user
    }

    public func deleteUser(id: String) async throws {}

    public func fetchFavoritePropertyIds(userId: String) async throws -> [String] {
        []
    }

    public func addFavoriteProperty(userId: String, propertyId: String) async throws {}

    public func removeFavoriteProperty(userId: String, propertyId: String) async throws {}
}
