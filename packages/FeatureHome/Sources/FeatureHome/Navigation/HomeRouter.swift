//
//  HomeRouter.swift
//  FeatureHome
//
//  Created by builder on 5/24/26.
//


enum HomeRouter {
    
    static func push(
        _ destination: HomeDestination,
        into path: inout NavigationPath
    ) {
        path.append(destination)
    }
}