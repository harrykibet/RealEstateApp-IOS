import Foundation
import model

public protocol PropertyRemoteDataSource {
    func fetchProperty(id: String) async throws -> PropertyModel
    func fetchProperties() async throws -> [PropertyModel]
    func searchProperties(query: String?, filters: PropertySearchFilters) async throws -> [PropertyModel]
    func createProperty(_ property: PropertyModel) async throws -> PropertyModel
    func updateProperty(_ property: PropertyModel) async throws -> PropertyModel
    func deleteProperty(id: String) async throws
}

public final class NoopPropertyRemoteDataSource: PropertyRemoteDataSource {
    public init() {}

    public func fetchProperty(id: String) async throws -> PropertyModel {
        var property = PropertyModel()
        property.id = id
        return property
    }

    public func fetchProperties() async throws -> [PropertyModel] {
        []
    }

    public func searchProperties(query: String?, filters: PropertySearchFilters) async throws -> [PropertyModel] {
        []
    }

    public func createProperty(_ property: PropertyModel) async throws -> PropertyModel {
        property
    }

    public func updateProperty(_ property: PropertyModel) async throws -> PropertyModel {
        property
    }

    public func deleteProperty(id: String) async throws {}
}
