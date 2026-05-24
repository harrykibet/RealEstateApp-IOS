//
//  AuthRootView.swift
//  FeatureAuth
//
//  Created by builder on 5/24/26.
//


struct AuthRootView: View {
    
    @Environment(\.navigation) private var navigation
    
    var body: some View {
        LoginView(
            
            onLoginSuccess: {
                navigation.authCompleted()   // GLOBAL NAV
            },
            
            onTapSignup: {
                // LOCAL NAV (internal stack push)
            }
        )
    }
}