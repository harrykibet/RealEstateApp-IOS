//
//  ServiceProvider.swift
//  model
//
//  Created by builder on 5/3/25.
//


import Foundation

struct ServiceProvider {
    var id: String
    var name: String
    var serviceType: ServiceType
    var description: String?
    var contactPhone: String
    var contactEmail: String?
    var websiteUrl: String?
    var location: UserLocation?
    var serviceAreas: [String]
    var ratings: Float?
    var reviewsCount: Int
    var verified: Bool
    var images: [String]
    var createdAt: Date?
}
