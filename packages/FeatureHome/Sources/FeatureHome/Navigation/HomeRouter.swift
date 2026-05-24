//
//  HomeRouter.swift
//  FeatureHome
//
//  Created by builder on 5/24/26.
//

import SwiftUI

public enum HomeRouter {
    
    public static func push(
        _ destination: HomeDestination,
        into path: inout NavigationPath
    ) {
        path.append(destination)
    }
    
    public static func resolve(
        _ destination: HomeDestination,
        router: AppRouter
    ) -> AnyView {
        
        switch destination {
        case .feed:
            return AnyView(HomeFeedView(router: router))
            
        case .propertyDetails(let id):
            return AnyView(PropertyDetailsView(propertyID: id))
        }
    }
}
