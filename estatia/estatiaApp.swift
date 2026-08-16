//
//  estatiaApp.swift
//  estatia
//
//  Created by builder on 5/1/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let container: AppDIContainer
    @StateObject private var navigationState: NavigationState
    @StateObject private var coordinator: AppCoordinator

    init() {
        let container = AppDIContainer()
        self.container = container

        // Initialize NavigationState first so it can be passed into the coordinator
        let navState = NavigationState()
        _navigationState = StateObject(wrappedValue: navState)
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container, navigationState: navState))
    }

    var body: some Scene {
        WindowGroup {
            let actions = AppNavigationController(state: navigationState).makeActions()

            coordinator.makeRootView()
                .environment(\.di, container)
                .environment(\.navigation, actions)
                .environmentObject(navigationState)
        }
    }
}
