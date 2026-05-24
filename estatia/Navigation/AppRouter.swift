//
//  AppRouter.swift
//  estatia
//
//  Created by builder on 5/24/26.
//

import CoreDesignSystem
import FeatureHome
import FeatureProfile
import FeatureSearch


@MainActor
public final class AppRouter {
    
    private let state: NavigationState
    
    init(state: NavigationState) {
        self.state = state
    }
}

extension AppRouter {
    
    func switchTab(_ tab: AppTabID) {
        state.selectedTab = tab
    }
    
    func navigate(to destination: AppDestination) {
        switch destination {
            
        case .home(let route):
            state.selectedTab = .home
            HomeRouter.push(route, into: &state.homePath)
            
        case .profile(let route):
            state.selectedTab = .profile
            ProfileRouter.push(route, into: &state.profilePath)
            
        case .search(let route):
            state.selectedTab = .search
            ExploreRouter.push(route, into: &state.explorePath)
        }
    }
}
