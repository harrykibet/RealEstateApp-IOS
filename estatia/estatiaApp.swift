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
    @StateObject private var coordinator: AppCoordinator

    init() {
        let container = AppDIContainer()
        self.container = container
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }

    var body: some Scene {
        WindowGroup {
            coordinator.makeRootView()
        }
    }
}
