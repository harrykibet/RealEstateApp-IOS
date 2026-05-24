//
//  HomeRootView.swift
//  FeatureHome
//
//  Created by builder on 5/24/26.
//


import SwiftUI

public struct HomeRootView: View {
    
    @ObservedObject var router: AppRouter
    @EnvironmentObject var navigationState: NavigationState
    
    public var body: some View {
        NavigationStack(path: $navigationState.homePath) {
            
            HomeFeedView(router: router)
            
            .navigationDestination(for: HomeDestination.self) { destination in
                HomeRouter.resolve(destination, router: router)
            }
        }
    }
}