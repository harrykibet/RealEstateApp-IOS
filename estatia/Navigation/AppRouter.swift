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
final class AppRouter {
    
    private let state: NavigationState
    
    init(state: NavigationState) {
        self.state = state
    }
    
    func switchTab(_ tab: AppTabID) {
        state.selectedTab = tab
    }
}
