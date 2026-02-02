//
//  MainTabView.swift
//  estatia
//
//  Created by builder on 5/8/25.
//


import SwiftUI

struct MainTabView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            coordinator.view(for: .home)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(AppCoordinator.AppTab.home)

            coordinator.view(for: .search)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(AppCoordinator.AppTab.search)

            coordinator.view(for: .property)
                .tabItem {
                    Label("Add", systemImage: "plus.app.fill")
                }
                .tag(AppCoordinator.AppTab.add)

            coordinator.view(for: .profile(coordinator.currentUser))
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(AppCoordinator.AppTab.profile)
        }
        .accentColor(.primary)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(coordinator: AppCoordinator(container: AppDIContainer()))
    }
}
