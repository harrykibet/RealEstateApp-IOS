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
    
    private let navigationController: AppNavigationController
    
    init() {
        let state = NavigationState()
        self._state = StateObject(wrappedValue: state)
        self.navigationController = AppNavigationController(state: state)
    }
    
    var body: some View {
        let actions = navigationController.makeActions()
        
        TabView(selection: $state.selectedTab) {
            
            HomeRootView()
                .tabItem { Text("Home") }
                .tag(AppTabID.home)
            
            SearchRootView()
                .tabItem { Text("Search") }
                .tag(AppTabID.search)
            
            ProfileRootView()
                .tabItem { Text("Profile") }
                .tag(AppTabID.profile)
        }
        .environment(\.navigation, actions)
        .environmentObject(state)
    }
}
