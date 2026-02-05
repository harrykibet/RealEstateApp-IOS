import Foundation
import model
import network

public protocol UserRepository: Repository {
    func fetchUser(id: String) async throws -> User
    func updateUser(_ user: User) async throws -> User
    func deleteUser(id: String) async throws
    func fetchFavoritePropertyIds(userId: String) async throws -> [String]
    func addFavoriteProperty(userId: String, propertyId: String) async throws
    func removeFavoriteProperty(userId: String, propertyId: String) async throws
}

public final class RemoteUserRepository: UserRepository {
    private let remote: UserRemoteDataSource

    public init(remote: UserRemoteDataSource) {
        self.remote = remote
    }

    public func fetchUser(id: String) async throws -> User {
        try await remote.fetchUser(id: id)
    }

    public func updateUser(_ user: User) async throws -> User {
        try await remote.updateUser(user)
    }

    public func deleteUser(id: String) async throws {
        try await remote.deleteUser(id: id)
    }

    public func fetchFavoritePropertyIds(userId: String) async throws -> [String] {
        try await remote.fetchFavoritePropertyIds(userId: userId)
    }

    public func addFavoriteProperty(userId: String, propertyId: String) async throws {
        try await remote.addFavoriteProperty(userId: userId, propertyId: propertyId)
    }

    public func removeFavoriteProperty(userId: String, propertyId: String) async throws {
        try await remote.removeFavoriteProperty(userId: userId, propertyId: propertyId)
    }
}
