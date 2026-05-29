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

    @StateObject
    private var loginViewModel: LoginViewModel

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
            loginView

        case .authenticated(_, let status):

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
}

extension AuthRootView {
    
    private var loginView: some View {
        LoginView(
            viewModel: LoginViewModel(authRepository: authRepository),
            onLoginResult: handleLoginResult,
            onSignupTapped: {
                authSession.status = .unauthenticated // stays in same state machine
            },
            onForgotPasswordTapped: {
                authSession.status = .unauthenticated
            }
        )
    }
    
    private func handleLoginResult(_ result: AuthenticationResult) {
        
        switch result {
            
        case .authenticated:
            authSession.status = .authenticated
            
        case .requiresEmailVerification(let email):
            authSession.status = .pendingVerification(.email)
            
        case .requiresPhoneVerification(let phone):
            authSession.status = .pendingVerification(.phone)
        }
    }
    
    @ViewBuilder
    private func verificationView(_ type: VerificationType) -> some View {

        switch type {

        case .email:
            EmailVerificationView(
                onVerificationSuccess: {
                    authSession.updatingStatus(
                        .authenticated
                    )
                }
            )

        case .phone:
            PhoneVerificationView(
                onVerificationSuccess: {
                    authSession.status = .authenticated
                }
            )

        case .mfa:
            Text("MFA not implemented")
        }
    }}
