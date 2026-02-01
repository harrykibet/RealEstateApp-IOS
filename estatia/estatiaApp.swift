//
//  estatiaApp.swift
//  estatia
//
//  Created by builder on 5/1/25.
//

import SwiftUI
import FirebaseCore
import model

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

    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainTabView(user: mockUser) // ✅ Inject mock user here
            }
        }
    }

    // ✅ Mock user instance
    var mockUser: User {
        User(
            userId: "demo_001",
            name: "Harry Kibet",
            email: "harry@example.com",
            phoneNumber: "+254712345678",
            profilePictureUrl: "https://i.pravatar.cc/150?img=3",
            userType: .landlord,
            verified: true,
            likedProperties: ["property_a", "property_b"]
        )
    }
}
