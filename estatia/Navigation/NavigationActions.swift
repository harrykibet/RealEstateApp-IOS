//
//  NavigationActions.swift
//  estatia
//
//  Created by builder on 5/24/26.
//

import CoreDesignSystem
import FeatureProfile
import FeatureSearch


public struct NavigationActions {
    
    // MARK: - Global Navigation
    
    public var switchTab: (AppTabID) -> Void
    public var navigateHome: () -> Void
    public var navigateProfile: (ProfileDestination) -> Void
    public var navigateSearch: (SearchDestination) -> Void
    
    // MARK: - Auth Flow (global boundary)
    
    public var authCompleted: () -> Void
}
