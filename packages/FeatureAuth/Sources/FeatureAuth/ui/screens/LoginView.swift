//
//  ContentView.swift
//  auth
//
//  Created by builder on 5/3/25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel: LoginViewModel
    
    let onLoginResult: (LoginResult) -> Void
    
    let onSignupTapped: () -> Void
    
    let onForgotPasswordTapped: () -> Void
    
    var body: some View {
        
        VStack {
            
            Button("Login") {
                
                Task {
                    guard let result = await viewModel.login()
                    else { return }
                    
                    onLoginResult(result)
                }
            }
            
            Button("Signup") {
                onSignupTapped()
            }
            
            Button("Forgot Password") {
                onForgotPasswordTapped()
            }
        }
    }
}
