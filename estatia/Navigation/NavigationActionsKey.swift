//
//  NavigationActionsKey.swift
//  estatia
//
//  Created by builder on 5/24/26.
//


import SwiftUI

private struct NavigationActionsKey: EnvironmentKey {
    
    static let defaultValue = NavigationActions(
        switchTab: { _ in },
        navigateHome: {},
        navigateProfile: { _ in },
        navigateSearch: { _ in },
        authCompleted: {}
    )
}

extension EnvironmentValues {
    var navigation: NavigationActions {
        get { self[NavigationActionsKey.self] }
        set { self[NavigationActionsKey.self] = newValue }
    }
}