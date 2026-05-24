//
//  RootAppView.swift
//  estatia
//
//  Created by builder on 5/24/26.
//

import SwiftUI
import CoreDesignSystem
import FeatureHome
import FeatureSearch
import FeatureProfile


struct RootAppView: View {
    
    @StateObject private var state = NavigationState()
    private let router: AppRouter
    
    init() {
        let state = NavigationState()
        self._state = StateObject(wrappedValue: state)
        self.router = AppRouter(state: state)
    }
    
    var body: some View {
        TabView(selection: $state.selectedTab) {
            
            HomeRootView(router: router)
                .tabItem { Text("Home") }
                .tag(AppTabID.home)
            
            SearchRootView(router: router)
                .tabItem { Text("Search") }
                .tag(AppTabID.search)
            
            ProfileRootView(router: router)
                .tabItem { Text("Profile") }
                .tag(AppTabID.profile)
        }
        .environmentObject(state)
    }
}
