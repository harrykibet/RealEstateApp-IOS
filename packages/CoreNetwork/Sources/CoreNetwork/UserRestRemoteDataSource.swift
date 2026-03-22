import Foundation
import CoreModel

public final class UserRestRemoteDataSource: UserRemoteDataSource {
    private let client: APIClient
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    public init(client: APIClient, decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder()) {
        self.client = client
        self.decoder = decoder
        self.encoder = encoder
    }

    public func fetchUser(id: String) async throws -> User {
        let data = try await client.get("/users/\(id)")
        return try decoder.decode(User.self, from: data)
    }

    public func updateUser(_ user: User) async throws -> User {
        guard let userId = user.userId, !userId.isEmpty else {
            throw RemoteDataSourceError.missingUserId
        }
        let data = try await client.put("/users/\(userId)", body: try encoder.encode(user))
        return try decoder.decode(User.self, from: data)
    }

    public func deleteUser(id: String) async throws {
        _ = try await client.delete("/users/\(id)")
    }

    public func fetchFavoritePropertyIds(userId: String) async throws -> [String] {
        let data = try await client.get("/users/\(userId)/favorites")
        return try decoder.decode([String].self, from: data)
    }

    public func addFavoriteProperty(userId: String, propertyId: String) async throws {
        let body = try encoder.encode(FavoritePayload(propertyId: propertyId))
        _ = try await client.post("/users/\(userId)/favorites", body: body)
    }

    public func removeFavoriteProperty(userId: String, propertyId: String) async throws {
        _ = try await client.delete("/users/\(userId)/favorites/\(propertyId)")
    }
}

private struct FavoritePayload: Codable {
    let propertyId: String
}
