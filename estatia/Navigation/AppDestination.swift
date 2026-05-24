//
//  AppDestination.swift
//  estatia
//
//  Created by builder on 5/24/26.
//

import FeatureHome
import FeatureSearch
import FeatureProfile

enum AppDestination: Hashable, Sendable {
    case home(HomeDestination)
    case search(SearchDestination)
    case profile(ProfileDestination)
}
