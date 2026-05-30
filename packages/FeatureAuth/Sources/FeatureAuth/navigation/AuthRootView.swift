//
//  AuthRootView.swift
//  FeatureAuth
//
//  Created by builder on 5/24/26.
//

import SwiftUI
import CoreModel
import CoreAppData

public struct AuthRootView: View {

    // MARK: - State

    @State
    private var authSession: AuthSession = .unauthenticated
    
    @State
    private var flowState: AuthFlowState = .login
    
    @StateObject
    private var loginViewModel: LoginViewModel
    
    @StateObject
    private var signupViewModel: SignupViewModel
    
    @StateObject
    private var emailVerificationViewModel: EmailVerificationViewModel
    
    @StateObject
    private var forgotPasswordViewModel: ForgotPasswordViewModel
    
    @StateObject
    private var phoneVerificationViewModel: PhoneVerificationViewModel
    
    // MARK: - Dependencies

    private let authRepository: AuthRepository
    private let onAuthenticated: () -> Void

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
        
        _forgotPasswordViewModel = StateObject(
            wrappedValue: ForgotPasswordViewModel(
                authRepository: authRepository
            )
        )
        
        _emailVerificationViewModel = StateObject(
            wrappedValue: EmailVerificationViewModel(
                authRepository: authRepository
            )
        )
        
        _phoneVerificationViewModel = StateObject(
            wrappedValue: PhoneVerificationViewModel(
                authRepository: authRepository
            )
        )
    }

    public var body: some View {
        content
    }
}

extension AuthRootView {
    
    @ViewBuilder
    private var content: some View {
        
        switch authSession {
            
        case .unauthenticated:
            
            unauthenticatedContent
            
        case .authenticated(_, let status):
            
            authenticatedContent(
                for: status
            )
        }
    }
    
    @ViewBuilder
    private var unauthenticatedContent: some View {
        
        switch flowState {
            
        case .login:
            
            loginView
            
        case .signup:
            
            signupView
            
        case .forgotPassword:
            
            forgotPasswordView
            
        case .verification(let type):
            
            verificationView(type)
        }
    }
    
    @ViewBuilder
    private func authenticatedContent(
        for status: AuthStatus
    ) -> some View {
        
        switch status {
            
        case .authenticated:
            
            Color.clear
                .onAppear {
                    onAuthenticated()
                }
            
        case .pendingVerification(let type):
            
            verificationView(type)
            
        case .restricted:
            
            Text("Account restricted")
        }
    }
}

extension AuthRootView {
    
    private var loginView: some View {
        
        LoginView(
            viewModel: loginViewModel,
            
            onAuthSessionReceived: handleAuthSession,
            
            onSignupTapped: {
                flowState = .signup
            },
            
            onForgotPasswordTapped: {
                flowState = .forgotPassword
            }
        )
    }
    
    private var signupView: some View {
        
        SignupView(
            viewModel: signupViewModel,
            
            onSignupCompleted: handleAuthSession,
            
            onBackToLogin: {
                flowState = .login
            }
        )
    }
    
    private var forgotPasswordView: some View {
        
        ForgotPasswordView(
            viewModel: forgotPasswordViewModel,
            
            onBackToLogin: {
                flowState = .login
            }
        )
    }
    
    private func handleAuthSession(
        _ session: AuthSession
    ) {
        
        authSession = session
        
        guard case let .authenticated(
            _,
            status
        ) = session else {
            return
        }
        
        if case .pendingVerification(let type) = status {
            flowState = .verification(type)
        }
    }
}

extension AuthRootView {
    
    private func completeVerification() {

        authSession = authSession.updatingStatus(
            .authenticated
        )
    }
    
    @ViewBuilder
    private func verificationView(
        _ type: VerificationType
    ) -> some View {

        switch type {

        case .email:

            EmailVerificationView(
                viewModel: emailVerificationViewModel,
                onVerificationSuccess: completeVerification
            )

        case .phone:

            PhoneVerificationView(
                onVerificationSuccess: completeVerification
            )

        case .mfa:

            Text("MFA not implemented")
        }
    }
}
