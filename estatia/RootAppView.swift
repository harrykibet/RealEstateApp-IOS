//
//  RootAppView.swift
//  estatia
//
//  Created by builder on 5/24/26.
//

import SwiftUI
import CoreDesignSystem


struct RootAppView: View {
    
    @StateObject private var state: NavigationState
    private let router: AppRouter
    
    var body: some View {
        TabView(selection: $state.selectedTab) {
            
            NavigationStack(path: $state.homePath) {
                HomeRootView(router: router)
            }
            .tabItem { Text("Home") }
            .tag(AppTabID.home)
            
            NavigationStack(path: $state.$explorePath) {
                SearchRootView(router: router)
            }
            .tabItem { Text("Search") }
            .tag(AppTabID.search)
            
            NavigationStack(path: $state.profilePath) {
                ProfileRootView(router: router)
            }
            .tabItem { Text("Profile") }
            .tag(AppTabID.profile)
        }
    }
}
