//
//  NavigationState.swift
//  estatia
//
//  Created by builder on 5/24/26.
//

import Foundation
import CoreDesignSystem
import SwiftUI


@MainActor
final class NavigationState: ObservableObject {
    
    @Published var selectedTab: AppTabID = .home
    
    @Published var homePath = NavigationPath()
    @Published var explorePath = NavigationPath()
    @Published var savedPath = NavigationPath()
    @Published var inboxPath = NavigationPath()
    @Published var profilePath = NavigationPath()
}
