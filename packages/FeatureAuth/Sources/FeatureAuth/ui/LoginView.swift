//
//  LoginView.swift
//  FeatureAuth
//
//  Created by builder on 5/24/26.
//

import SwiftUI


struct LoginView: View {
    
    let onLoginSuccess: () -> Void
    let onTapSignup: () -> Void
    
    var body: some View {
        VStack {
            
            Button("Login") {
                onLoginSuccess()
            }
            
            Button("Create account") {
                onTapSignup()
            }
        }
    }
}
