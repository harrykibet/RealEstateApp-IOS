import Testing
import model
import network
@testable import data

@Test func userRepositoryForwardsFavorites() async throws {
    let remote = MockUserRemoteDataSource()
    let repository = RemoteUserRepository(remote: remote)

    try await repository.addFavoriteProperty(userId: "user-1", propertyId: "prop-2")

    #expect(remote.lastAddedFavorite?.userId == "user-1")
    #expect(remote.lastAddedFavorite?.propertyId == "prop-2")
}

@Test func propertyRepositorySearches() async throws {
    let remote = MockPropertyRemoteDataSource()
    let repository = RemotePropertyRepository(remote: remote)
    let filters = PropertySearchFilters(county: "King")

    _ = try await repository.searchProperties(query: "loft", filters: filters)

    #expect(remote.lastSearch?.query == "loft")
    #expect(remote.lastSearch?.filters.county == "King")
}

final class MockUserRemoteDataSource: UserRemoteDataSource {
    var lastAddedFavorite: (userId: String, propertyId: String)?

    func fetchUser(id: String) async throws -> User {
        User(userId: id)
    }

    func updateUser(_ user: User) async throws -> User {
        user
    }

    func deleteUser(id: String) async throws {}

    func fetchFavoritePropertyIds(userId: String) async throws -> [String] {
        []
    }

    func addFavoriteProperty(userId: String, propertyId: String) async throws {
        lastAddedFavorite = (userId, propertyId)
    }

    func removeFavoriteProperty(userId: String, propertyId: String) async throws {}
}

final class MockPropertyRemoteDataSource: PropertyRemoteDataSource {
    var lastSearch: (query: String?, filters: PropertySearchFilters)?

    func fetchProperty(id: String) async throws -> PropertyModel {
        var property = PropertyModel()
        property.id = id
        return property
    }

    func fetchProperties() async throws -> [PropertyModel] {
        []
    }

    func searchProperties(query: String?, filters: PropertySearchFilters) async throws -> [PropertyModel] {
        lastSearch = (query, filters)
        return []
    }

    func createProperty(_ property: PropertyModel) async throws -> PropertyModel {
        property
    }

    func updateProperty(_ property: PropertyModel) async throws -> PropertyModel {
        property
    }

    func deleteProperty(id: String) async throws {}
}
