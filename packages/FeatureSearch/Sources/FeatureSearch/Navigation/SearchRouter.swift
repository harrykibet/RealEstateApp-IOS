//
//  SearchRouter.swift
//  FeatureSearch
//
//  Created by builder on 5/24/26.
//


import SwiftUI

public enum SearchRouter {
    
    public static func push(
        _ destination: SearchDestination,
        into path: inout NavigationPath
    ) {
        path.append(destination)
    }
    
    public static func resolve(
        _ destination: SearchDestination,
        router: AppRouter
    ) -> AnyView {
        
        switch destination {
        case .results(let query):
            return AnyView(SearchResultsView(query: query, router: router))
            
        case .propertyDetails(let id):
            return AnyView(PropertyDetailsView(propertyID: id))
        }
    }
}