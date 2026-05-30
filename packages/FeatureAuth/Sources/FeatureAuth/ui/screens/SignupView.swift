//
//  SignupView.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import SwiftUI
import CoreModel

public struct SignupView: View {
    
    // MARK: - ViewModel
    
    @ObservedObject
    private var viewModel: SignupViewModel
    
    // MARK: - Intents
    
    private let onAuthSessionReceived: (AuthSession) -> Void
    
    private let onBackToLoginTapped: () -> Void
    
    // MARK: - Init
    
    public init(
        viewModel: SignupViewModel,
        onAuthSessionReceived: @escaping (AuthSession) -> Void,
        onBackToLoginTapped: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onAuthSessionReceived = onAuthSessionReceived
        self.onBackToLoginTapped = onBackToLoginTapped
    }
    
    // MARK: - Body
    
    public var body: some View {
        
        VStack(spacing: 16) {
            
            Text("Create Account")
                .font(.largeTitle.bold())
            
            TextField(
                "Email",
                text: $viewModel.form.email
            )
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .textFieldStyle(.roundedBorder)
            
            SecureField(
                "Password",
                text: $viewModel.form.password
            )
            .textFieldStyle(.roundedBorder)
            
            SecureField(
                "Confirm Password",
                text: $viewModel.form.confirmPassword
            )
            .textFieldStyle(.roundedBorder)
            
            if let error = viewModel.uiState.errorMessage {
                
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button {
                
                Task {
                    await handleSignup()
                }
                
            } label: {
                
                if viewModel.uiState.isLoading {
                    ProgressView()
                } else {
                    Text("Sign Up")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.uiState.isLoading)
            
            Button("Back to Login") {
                onBackToLoginTapped()
            }
            .font(.caption)
        }
        .padding()
    }
}

extension SignupView {
    
    private func handleSignup() async {
        
        guard let result = await viewModel.signup() else {
            return
        }
        
        onSignupCompleted(result)
    }
}
