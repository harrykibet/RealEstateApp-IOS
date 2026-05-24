//
//  AuthRootView.swift
//  FeatureAuth
//
//  Created by builder on 5/24/26.
//

import SwiftUI
import CoreAppData


public struct AuthRootView: View {
    
    // MARK: - State
    
    @State private var path: [AuthDestination] = []
    
    // MARK: - Dependencies
    
    private let authRepository: AuthRepository
    
    // MARK: - Global Navigation
    
    @Environment(\.navigation) private var navigation
    
    // MARK: - Init
    
    public init(
        authRepository: AuthRepository
    ) {
        self.authRepository = authRepository
    }
    
    // MARK: - Body
    
    public var body: some View {
        
        NavigationStack(path: $path) {
            
            LoginView(
                
                viewModel: LoginViewModel(
                    authRepository: authRepository
                ),
                
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
        _ result: LoginResult
    ) {
        switch result {
            
        case .authenticated:
            navigation.authCompleted()
            
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
                
            SignupView(
                onSignupCompleted: handleSignupCompleted
            )
            
        case .forgotPassword:
                
            ForgotPasswordView()
            
        case .phoneVerification(let phone):
                
            PhoneVerificationView(
                phone: phone,
                onVerificationSuccess: {
                    navigation.authCompleted()
                }
            )
            
        case .emailVerification(let email):
                
            EmailVerificationView(
                email: email,
                onVerificationSuccess: {
                    navigation.authCompleted()
                }
            )
        }
    }
}
