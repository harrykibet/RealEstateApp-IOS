//
//  property.swift
//  model
//
//  Created by builder on 5/3/25.
//
import Foundation

public struct PropertyModel: Codable, Identifiable {
    public var id: String?
    public var title: String?
    public var description: String?
    public var price: Double?
    public var imageUrl: [String]
    public var videoUrl: [String]
    public var video: Bool
    public var latitude: Double?
    public var longitude: Double?
    public var createdAt: Date?
    public var ownerId: String?
    public var ownerName: String?
    public var contactPhone: String?
    public var contactEmail: String?
    public var county: String?
    public var active: Bool
    public var viewsCount: Int?
    public var propertyType: String?
    public var bedrooms: Int?
    public var bathrooms: Int?
    public var areaSize: Double?
    public var amenities: [String]?
    public var features: String?
    public var depositAmount: Double?
    public var address: String?
    public var availableFrom: String?
    public var leaseTerms: String?
    public var available: Bool
    
    public init() {
        self.id = nil
        self.title = nil
        self.description = nil
        self.price = nil
        self.imageUrl = []
        self.videoUrl = []
        self.video = false
        self.latitude = nil
        self.longitude = nil
        self.createdAt = nil
        self.ownerId = nil
        self.ownerName = nil
        self.contactPhone = nil
        self.contactEmail = nil
        self.county = nil
        self.active = false
        self.viewsCount = nil
        self.propertyType = nil
        self.bedrooms = nil
        self.bathrooms = nil
        self.areaSize = nil
        self.amenities = nil
        self.features = nil
        self.depositAmount = nil
        self.address = nil
        self.availableFrom = nil
        self.leaseTerms = nil
        self.available = false
    }
}
