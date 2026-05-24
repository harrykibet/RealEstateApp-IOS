//
//  SearchRootView.swift
//  FeatureSearch
//
//  Created by builder on 5/24/26.
//


import SwiftUI

public struct SearchRootView: View {
    
    @ObservedObject var router: AppRouter
    @EnvironmentObject var navigationState: NavigationState
    
    public var body: some View {
        NavigationStack(path: $navigationState.searchPath) {
            
            SearchView(router: router)
            
            .navigationDestination(for: SearchDestination.self) { destination in
                SearchRouter.resolve(destination, router: router)
            }
        }
    }
}