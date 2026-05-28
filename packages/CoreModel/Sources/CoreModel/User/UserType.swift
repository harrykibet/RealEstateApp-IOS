//
//  UserType.swift
//  model
//
//  Created by builder on 5/3/25.
//


//
//  user.swift
//  model
//
//  Created by builder on 5/3/25.
//
import Foundation

public enum UserType: String, Codable, Sendable, Equatable {
    case tenant
    case landlord
    case admin
}


