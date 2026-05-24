//
//  AppRouter.swift
//  estatia
//
//  Created by builder on 5/24/26.
//

import CoreDesignSystem


@MainActor
final class AppRouter {
    
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
            
        case .inbox(let route):
            state.selectedTab = .inbox
            InboxRouter.push(route, into: &state.inboxPath)
            
        case .saved(let route):
            state.selectedTab = .saved
            SavedRouter.push(route, into: &state.savedPath)
            
        case .explore(let route):
            state.selectedTab = .explore
            ExploreRouter.push(route, into: &state.explorePath)
        }
    }
}
