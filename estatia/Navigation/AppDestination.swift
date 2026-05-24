//
//  AppDestination.swift
//  estatia
//
//  Created by builder on 5/24/26.
//


enum AppDestination: Hashable, Sendable {
    case home(HomeDestination)
    case explore(ExploreDestination)
    case saved(SavedDestination)
    case inbox(InboxDestination)
    case profile(ProfileDestination)
}