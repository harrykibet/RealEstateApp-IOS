//
//  AppTab.swift
//  CoreDesignSystem
//
//  Created by builder on 4/14/26.
//


public enum AppTab: String, CaseIterable {
    case home
    case search
    case profile
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .profile: return "Profile"
        }
    }
}
