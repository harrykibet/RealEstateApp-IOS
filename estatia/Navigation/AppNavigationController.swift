//
//  AppNavigationController.swift
//  estatia
//
//  Created by builder on 5/24/26.
//


final class AppNavigationController {
    
    let state: NavigationState
    
    init(state: NavigationState) {
        self.state = state
    }
    
    func makeActions() -> NavigationActions {
        NavigationActions(
            switchTab: { [state] tab in
                state.selectedTab = tab
            },
            
            navigateHome: { [state] in
                state.selectedTab = .home
            },
            
            navigateProfile: { [state] destination in
                state.selectedTab = .profile
                state.profilePath.append(destination)
            },
            
            navigateSearch: { [state] destination in
                state.selectedTab = .search
                state.searchPath.append(destination)
            },
            
            authCompleted: { [state] in
                state.selectedTab = .home
                state.authStack = []
            }
        )
    }
}