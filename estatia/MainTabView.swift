//
//  MainTabView.swift
//  estatia
//
//  Created by builder on 5/8/25.
//


import SwiftUI
import CoreDesignSystem

struct MainTabView: View {
    @ObservedObject var coordinator: AppCoordinator
    @EnvironmentObject private var navigationState: NavigationState
    @State private var showAddSheet = false

    var body: some View {
        ZStack {
            TabView(selection: $navigationState.selectedTab) {
                coordinator.view(for: .home)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(AppTabID.home)

                coordinator.view(for: .search)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(AppTabID.search)

                coordinator.view(for: .profile(coordinator.currentUser))
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(AppTabID.profile)
            }
            .accentColor(.primary)

            VStack {
                Spacer()
                Button(action: { showAddSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.accentColor)
                        .padding(6)
                        .background(Circle().fill(Color(UIColor.systemBackground)).shadow(radius: 4))
                }
                .offset(y: -24)
            }
        }
        .sheet(isPresented: $showAddSheet) {
            coordinator.view(for: .property)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let nav = NavigationState()
        MainTabView(coordinator: AppCoordinator(container: AppDIContainer(), navigationState: nav))
            .environmentObject(nav)
    }
}
