//
//  MainTabView.swift
//  estatia
//
//  Created by builder on 5/8/25.
//


import SwiftUI
import profile
import home
import search
import property
import model

struct MainTabView: View {
    let user: User

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            AddPropertyView()
                .tabItem {
                    Label("Add", systemImage: "plus.app.fill")
                }

            UserProfileView(user: user)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .accentColor(.primary)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(user: User(
            userId: "123",
            name: "Harry Kibet",
            email: "harry@example.com",
            phoneNumber: "+254712345678",
            profilePictureUrl:"https://i.pravatar.cc/150?img=3",
            userType: .landlord,
            verified: true,
            likedProperties: ["property_1", "property_2"]
        ))
    }
}
