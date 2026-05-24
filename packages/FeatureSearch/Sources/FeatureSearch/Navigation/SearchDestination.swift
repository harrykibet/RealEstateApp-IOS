//
//  SearchDestination.swift
//  FeatureSearch
//
//  Created by builder on 5/24/26.
//


public enum SearchDestination: Hashable, Sendable {
    case results(query: String)
    case propertyDetails(id: String)
}