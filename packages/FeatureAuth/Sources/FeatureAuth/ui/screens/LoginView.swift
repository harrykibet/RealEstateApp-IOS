//
//  ContentView.swift
//  auth
//
//  Created by builder on 5/3/25.
//

import SwiftUI
import CoreModel


public struct LoginView: View {
    
    // MARK: - State
    
    @StateObject private var viewModel: LoginViewModel
    
    // MARK: - Actions
    
    private let onLoginResult: (AuthenticationResult) -> Void
    
    private let onSignupTapped: () -> Void
    
    private let onForgotPasswordTapped: () -> Void
    
    // MARK: - Init
    
    public init(
        viewModel: LoginViewModel,
        onLoginResult: @escaping (AuthenticationResult) -> Void,
        onSignupTapped: @escaping () -> Void,
        onForgotPasswordTapped: @escaping () -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
        
        self.onLoginResult = onLoginResult
        self.onSignupTapped = onSignupTapped
        self.onForgotPasswordTapped = onForgotPasswordTapped
    }
    
    // MARK: - Body
    
    public var body: some View {
        
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
