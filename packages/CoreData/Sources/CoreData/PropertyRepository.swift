import Foundation
import model
import network

public protocol PropertyRepository: Repository {
    func fetchProperty(id: String) async throws -> PropertyModel
    func fetchProperties() async throws -> [PropertyModel]
    func searchProperties(query: String?, filters: PropertySearchFilters) async throws -> [PropertyModel]
    func createProperty(_ property: PropertyModel) async throws -> PropertyModel
    func updateProperty(_ property: PropertyModel) async throws -> PropertyModel
    func deleteProperty(id: String) async throws
}

public final class RemotePropertyRepository: PropertyRepository {
    private let remote: PropertyRemoteDataSource

    public init(remote: PropertyRemoteDataSource) {
        self.remote = remote
    }

    public func fetchProperty(id: String) async throws -> PropertyModel {
        try await remote.fetchProperty(id: id)
    }

    public func fetchProperties() async throws -> [PropertyModel] {
        try await remote.fetchProperties()
    }

    public func searchProperties(query: String?, filters: PropertySearchFilters) async throws -> [PropertyModel] {
        try await remote.searchProperties(query: query, filters: filters)
    }

    public func createProperty(_ property: PropertyModel) async throws -> PropertyModel {
        try await remote.createProperty(property)
    }

    public func updateProperty(_ property: PropertyModel) async throws -> PropertyModel {
        try await remote.updateProperty(property)
    }

    public func deleteProperty(id: String) async throws {
        try await remote.deleteProperty(id: id)
    }
}
