//
//  User.swift
//  model
//
//  Created by builder on 5/3/25.
//


public struct User: Codable {
    public var userId: String?
    public var name: String?
    public var email: String?
    public var phoneNumber: String?
    public var profilePictureUrl: String?
    public var userType: UserType
    public var verified: Bool
    public var likedProperties: [String]

    public init(
        userId: String? = nil,
        name: String? = nil,
        email: String? = nil,
        phoneNumber: String? = nil,
        profilePictureUrl: String? = nil,
        userType: UserType = .tenant,
        verified: Bool = false,
        likedProperties: [String] = []
    ) {
        self.userId = userId
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.profilePictureUrl = profilePictureUrl
        self.userType = userType
        self.verified = verified
        self.likedProperties = likedProperties
    }
}
