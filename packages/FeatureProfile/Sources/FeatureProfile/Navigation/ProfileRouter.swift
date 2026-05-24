//
//  ProfileRouter.swift
//  FeatureProfile
//
//  Created by builder on 5/24/26.
//


import SwiftUI

public enum ProfileRouter {
    
    public static func push(
        _ destination: ProfileDestination,
        into path: inout NavigationPath
    ) {
        path.append(destination)
    }
    
    public static func resolve(
        _ destination: ProfileDestination,
        router: AppRouter
    ) -> AnyView {
        
        switch destination {
        case .view(let userID):
            return AnyView(ProfileView(userID: userID, router: router))
            
        case .edit:
            return AnyView(EditProfileView(router: router))
            
        case .settings:
            return AnyView(SettingsView(router: router))
        }
    }
}