//
//  ProfileRootView.swift
//  FeatureProfile
//
//  Created by builder on 5/24/26.
//


import SwiftUI

public struct ProfileRootView: View {
    
    @ObservedObject var router: AppRouter
    @EnvironmentObject var navigationState: NavigationState
    
    public var body: some View {
        NavigationStack(path: $navigationState.profilePath) {
            
            ProfileView(router: router)
            
            .navigationDestination(for: ProfileDestination.self) { destination in
                ProfileRouter.resolve(destination, router: router)
            }
        }
    }
}