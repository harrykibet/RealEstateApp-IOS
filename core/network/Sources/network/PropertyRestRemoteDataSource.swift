import Foundation
import model

public final class PropertyRestRemoteDataSource: PropertyRemoteDataSource {
    private let client: APIClient
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    public init(client: APIClient, decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder()) {
        self.client = client
        self.decoder = decoder
        self.encoder = encoder
    }

    public func fetchProperty(id: String) async throws -> PropertyModel {
        let data = try await client.get("/properties/\(id)")
        return try decoder.decode(PropertyModel.self, from: data)
    }

    public func fetchProperties() async throws -> [PropertyModel] {
        let data = try await client.get("/properties")
        return try decoder.decode([PropertyModel].self, from: data)
    }

    public func searchProperties(query: String?, filters: PropertySearchFilters) async throws -> [PropertyModel] {
        let queryItems = buildQueryItems(query: query, filters: filters)
        let data = try await client.get("/properties/search", query: queryItems)
        return try decoder.decode([PropertyModel].self, from: data)
    }

    public func createProperty(_ property: PropertyModel) async throws -> PropertyModel {
        let data = try await client.post("/properties", body: try encoder.encode(property))
        return try decoder.decode(PropertyModel.self, from: data)
    }

    public func updateProperty(_ property: PropertyModel) async throws -> PropertyModel {
        guard let propertyId = property.id, !propertyId.isEmpty else {
            throw RemoteDataSourceError.missingPropertyId
        }
        let data = try await client.put("/properties/\(propertyId)", body: try encoder.encode(property))
        return try decoder.decode(PropertyModel.self, from: data)
    }

    public func deleteProperty(id: String) async throws {
        _ = try await client.delete("/properties/\(id)")
    }

    private func buildQueryItems(query: String?, filters: PropertySearchFilters) -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let query, !query.isEmpty {
            items.append(URLQueryItem(name: "q", value: query))
        }
        if let minPrice = filters.minPrice {
            items.append(URLQueryItem(name: "minPrice", value: String(minPrice)))
        }
        if let maxPrice = filters.maxPrice {
            items.append(URLQueryItem(name: "maxPrice", value: String(maxPrice)))
        }
        if let bedrooms = filters.bedrooms {
            items.append(URLQueryItem(name: "bedrooms", value: String(bedrooms)))
        }
        if let bathrooms = filters.bathrooms {
            items.append(URLQueryItem(name: "bathrooms", value: String(bathrooms)))
        }
        if let county = filters.county, !county.isEmpty {
            items.append(URLQueryItem(name: "county", value: county))
        }
        if let propertyType = filters.propertyType, !propertyType.isEmpty {
            items.append(URLQueryItem(name: "propertyType", value: propertyType))
        }
        if let availableOnly = filters.availableOnly {
            items.append(URLQueryItem(name: "availableOnly", value: String(availableOnly)))
        }
        if let ownerId = filters.ownerId, !ownerId.isEmpty {
            items.append(URLQueryItem(name: "ownerId", value: ownerId))
        }
        return items
    }
}
