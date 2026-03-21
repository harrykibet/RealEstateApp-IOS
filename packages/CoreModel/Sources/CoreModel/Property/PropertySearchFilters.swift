import Foundation

public struct PropertySearchFilters: Codable, Equatable {
    public var minPrice: Double?
    public var maxPrice: Double?
    public var bedrooms: Int?
    public var bathrooms: Int?
    public var county: String?
    public var propertyType: String?
    public var availableOnly: Bool?
    public var ownerId: String?

    public init(
        minPrice: Double? = nil,
        maxPrice: Double? = nil,
        bedrooms: Int? = nil,
        bathrooms: Int? = nil,
        county: String? = nil,
        propertyType: String? = nil,
        availableOnly: Bool? = nil,
        ownerId: String? = nil
    ) {
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.bedrooms = bedrooms
        self.bathrooms = bathrooms
        self.county = county
        self.propertyType = propertyType
        self.availableOnly = availableOnly
        self.ownerId = ownerId
    }
}
