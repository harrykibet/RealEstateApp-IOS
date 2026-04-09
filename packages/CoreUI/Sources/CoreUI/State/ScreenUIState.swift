//
//  ScreenUIState.swift
//  CoreUI
//
//  Created by builder on 4/9/26.
//


public struct ScreenUIState {
    
    public let state: ScreenState
    
    public let isRefreshing: Bool
    
    public init(
        state: ScreenState,
        isRefreshing: Bool = false
    ) {
        self.state = state
        self.isRefreshing = isRefreshing
    }
}
