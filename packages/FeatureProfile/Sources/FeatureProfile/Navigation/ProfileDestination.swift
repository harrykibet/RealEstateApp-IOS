//
//  ProfileDestination.swift
//  FeatureProfile
//
//  Created by builder on 5/24/26.
//


public enum ProfileDestination: Hashable, Sendable {
    case view(id: String)
    case edit
    case settings
}