//
//  AuthRootView.swift
//  FeatureAuth
//
//  Created by builder on 5/24/26.
//

import SwiftUI
import CoreAppData

public struct AuthRootView: View {
    
    // MARK: - Navigation State
    
    @State private var path: [AuthDestination] = []
    
    // MARK: - ViewModels
    
    @StateObject
    private var loginViewModel: LoginViewModel
    
    @StateObject
    private var signupViewModel: SignupViewModel
    
    // MARK: - Dependencies
    
    private let authRepository: AuthRepository
    
    // MARK: - Cross-Feature Intents
    
    private let onAuthenticated: () -> Void
    
    // MARK: - Init
    
    public init(
        authRepository: AuthRepository,
        onAuthenticated: @escaping () -> Void
    ) {
        self.authRepository = authRepository
        self.onAuthenticated = onAuthenticated
        
        _loginViewModel = StateObject(
            wrappedValue: LoginViewModel(
                authRepository: authRepository
            )
        )
        
        _signupViewModel = StateObject(
            wrappedValue: SignupViewModel(
                authRepository: authRepository
            )
        )
    }
    
    // MARK: - Body
    
    public var body: some View {
        
        NavigationStack(path: $path) {
            
            LoginView(
                
                viewModel: loginViewModel,
                
                onLoginResult: handleLoginResult,
                
                onSignupTapped: {
                    path.append(.signup)
                },
                
                onForgotPasswordTapped: {
                    path.append(.forgotPassword)
                }
            )
            
            .navigationDestination(
                for: AuthDestination.self,
                destination: destinationView
            )
        }
    }
}

extension AuthRootView {
    
    private func handleLoginResult(
        _ result: AuthenticationResult
    ) {
        switch result {
            
        case .authenticated:
            
            // EMIT INTENT UPWARD
            
            onAuthenticated()
            
        case .requiresEmailVerification(let email):
            
            path.append(
                .emailVerification(email: email)
            )
            
        case .requiresPhoneVerification(let phone):
            
            path.append(
                .phoneVerification(phone: phone)
            )
        }
    }
}

extension AuthRootView {
    
    @ViewBuilder
    private func destinationView(
        for destination: AuthDestination
    ) -> some View {
        
        switch destination {
            
        case .signup:
            
        case .signup:
            
            SignupView(
                
                viewModel: signupViewModel,
                
                onSignupCompleted: handleSignupCompleted,
                
                onBackToLoginTapped: {
                    path.removeLast()
                }
            )
            
        case .forgotPassword:
            
            ForgotPasswordView()
            
        case .phoneVerification(let phone):
            
            PhoneVerificationView(
                phone: phone,
                onVerificationSuccess: {
                    onAuthenticated()
                }
            )
            
        case .emailVerification(let email):
            
            EmailVerificationView(
                email: email,
                onVerificationSuccess: {
                    onAuthenticated()
                }
            )
        }
    }
    
    private func handleSignupCompleted(
        _ result: AuthenticationResult
    ) {
        switch result {
            
        case .requiresEmailVerification(let email):
            path.append(
                .emailVerification(email: email)
            )
            
        case .requiresPhoneVerification(let phone):
            path.append(
                .phoneVerification(phone: phone)
            )
            
        case .authenticated:
            onAuthenticated()
        }
    }
}
