//
//  AppTab.swift
//  CoreDesignSystem
//
//  Created by builder on 5/23/26.
//

public enum AppTabID: String, CaseIterable, Hashable, Sendable, Identifiable {
    
    case home
    case explore
    case saved
    case inbox
    case profile
    
    public var id: Self {
        self
    }
}
