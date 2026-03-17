import Foundation
import model

public final class AuthRestRemoteDataSource: AuthRemoteDataSource {
    private let client: APIClient
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    public init(client: APIClient, decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder()) {
        self.client = client
        self.decoder = decoder
        self.encoder = encoder
    }

    public func signIn(email: String, password: String) async throws -> User {
        let payload = AuthCredentials(email: email, password: password)
        let data = try await client.post("/auth/signin", body: try encoder.encode(payload))
        return try decoder.decode(User.self, from: data)
    }

    public func signUp(email: String, password: String, displayName: String?) async throws -> User {
        let payload = SignUpPayload(email: email, password: password, displayName: displayName)
        let data = try await client.post("/auth/signup", body: try encoder.encode(payload))
        return try decoder.decode(User.self, from: data)
    }

    public func signOut() async throws {
        _ = try await client.post("/auth/signout", body: nil)
    }

    public func currentUser() async throws -> User? {
        let data = try await client.get("/auth/me")
        if data.isEmpty {
            return nil
        }
        return try decoder.decode(User.self, from: data)
    }
}

private struct AuthCredentials: Codable {
    let email: String
    let password: String
}

private struct SignUpPayload: Codable {
    let email: String
    let password: String
    let displayName: String?
}
