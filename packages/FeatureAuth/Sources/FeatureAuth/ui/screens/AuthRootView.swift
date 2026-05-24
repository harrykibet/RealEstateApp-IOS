//
//  AuthRootView.swift
//  FeatureAuth
//
//  Created by builder on 5/24/26.
//


import SwiftUI

public struct AuthRootView: View {
    
    // MARK: - State
    
    @State private var path: [AuthDestination] = []
    
    // MARK: - Global Navigation
    
    @Environment(\.navigation) private var navigation
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Body
    
    public var body: some View {
        NavigationStack(path: $path) {
            
            LoginView(
                
                onLoginSuccess: {
                    navigation.authCompleted()
                },
                
                onTapSignup: {
                    path.append(.signup)
                },
                
                onForgotPassword: {
                    path.append(.forgotPassword)
                }
            )
            
            .navigationDestination(for: AuthDestination.self) { destination in
                destinationView(for: destination)
            }
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
                
                onSignupCompleted: { email in
                    path.append(
                        .emailVerification(email: email)
                    )
                }
            )
            
        case .forgotPassword:
            
            ForgotPasswordView()
            
        case .phoneVerification(let phone):
            
            PhoneVerificationView(
                phone: phone
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
