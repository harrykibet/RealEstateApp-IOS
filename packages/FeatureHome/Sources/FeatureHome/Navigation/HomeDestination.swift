//
//  HomeDestination.swift
//  FeatureHome
//
//  Created by builder on 5/24/26.
//


public enum HomeDestination: Hashable, Sendable {
    case feed
    case propertyDetails(id: String)
}