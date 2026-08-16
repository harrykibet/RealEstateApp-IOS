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
            
            // default viewModel when used standalone inside the feature package
            let propertyRemote: PropertyRemoteDataSource = NoopPropertyRemoteDataSource()
            let propertyRepo = RemotePropertyRepository(remote: propertyRemote)
            let vm = SearchViewModel(repository: propertyRepo)

            SearchView(viewModel: vm)
            
            .navigationDestination(for: SearchDestination.self) { destination in
                SearchRouter.resolve(destination, router: router)
            }
        }
    }
}