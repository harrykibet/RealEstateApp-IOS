import Foundation
import Testing
import model
@testable import network

@Test func authRestRemoteDataSourceSignIn() async throws {
    let expected = User(userId: "user-1", name: "Ada", email: "ada@example.com")
    let responseData = try JSONEncoder().encode(expected)
    let client = StubAPIClient(responseData: responseData)
    let dataSource = AuthRestRemoteDataSource(client: client)

    let result = try await dataSource.signIn(email: "ada@example.com", password: "secret")

    #expect(client.lastMethod == "POST")
    #expect(client.lastPath == "/auth/signin")
    #expect(result.userId == expected.userId)
    #expect(result.email == expected.email)
}

@Test func propertyRestRemoteDataSourceSearchBuildsQuery() async throws {
    let responseData = try JSONEncoder().encode([PropertyModel()])
    let client = StubAPIClient(responseData: responseData)
    let dataSource = PropertyRestRemoteDataSource(client: client)
    let filters = PropertySearchFilters(minPrice: 1000, maxPrice: 2000, county: "King", availableOnly: true)

    _ = try await dataSource.searchProperties(query: "loft", filters: filters)

    #expect(client.lastMethod == "GET")
    #expect(client.lastPath == "/properties/search")
    #expect(client.lastQuery?.contains(where: { $0.name == "q" && $0.value == "loft" }) == true)
    #expect(client.lastQuery?.contains(where: { $0.name == "minPrice" && $0.value == "1000.0" }) == true)
    #expect(client.lastQuery?.contains(where: { $0.name == "county" && $0.value == "King" }) == true)
    #expect(client.lastQuery?.contains(where: { $0.name == "availableOnly" && $0.value == "true" }) == true)
}

@Test func userRestRemoteDataSourceAddsFavorite() async throws {
    let client = StubAPIClient(responseData: Data())
    let dataSource = UserRestRemoteDataSource(client: client)

    try await dataSource.addFavoriteProperty(userId: "user-1", propertyId: "prop-9")

    #expect(client.lastMethod == "POST")
    #expect(client.lastPath == "/users/user-1/favorites")
    let payload = try JSONDecoder().decode(FavoriteBody.self, from: client.lastBody ?? Data())
    #expect(payload.propertyId == "prop-9")
}

final class StubAPIClient: APIClient {
    var lastMethod: String?
    var lastPath: String?
    var lastQuery: [URLQueryItem]?
    var lastBody: Data?
    var responseData: Data

    init(responseData: Data) {
        self.responseData = responseData
    }

    func get(_ path: String, query: [URLQueryItem]?) async throws -> Data {
        record(method: "GET", path: path, query: query, body: nil)
        return responseData
    }

    func post(_ path: String, body: Data?) async throws -> Data {
        record(method: "POST", path: path, query: nil, body: body)
        return responseData
    }

    func put(_ path: String, body: Data?) async throws -> Data {
        record(method: "PUT", path: path, query: nil, body: body)
        return responseData
    }

    func delete(_ path: String) async throws -> Data {
        record(method: "DELETE", path: path, query: nil, body: nil)
        return responseData
    }

    private func record(method: String, path: String, query: [URLQueryItem]?, body: Data?) {
        lastMethod = method
        lastPath = path
        lastQuery = query
        lastBody = body
    }
}

private struct FavoriteBody: Codable {
    let propertyId: String
}
