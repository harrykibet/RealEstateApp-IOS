//
//  RootAppView.swift
//  estatia
//
//  Created by builder on 5/24/26.
//

import SwiftUI

// Deprecated duplicate root view.
// Navigation is centralized via AppCoordinator and NavigationState.
// Remove this file where possible; kept as a no-op placeholder to avoid accidental imports.

struct RootAppView: View {
    var body: some View {
        Text("Deprecated: RootAppView is no longer used. Use AppCoordinator.makeRootView() instead.")
            .multilineTextAlignment(.center)
            .padding()
    }
}

