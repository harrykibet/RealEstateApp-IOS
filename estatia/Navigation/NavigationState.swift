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
public final class NavigationState: ObservableObject {
    
    @Published var selectedTab: AppTabID = .home
    
    @Published var homePath = NavigationPath()
    @Published var searchPath = NavigationPath()
    @Published var profilePath = NavigationPath()
}
