//
//  AppRouter.swift
//  estatia
//
//  Created by builder on 5/24/26.
//


@MainActor
final class AppRouter {
    
    private let state: NavigationState
    
    init(state: NavigationState) {
        self.state = state
    }
}