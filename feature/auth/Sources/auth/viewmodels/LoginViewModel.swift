//
//  LoginViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//


import Foundation

@MainActor
public final class LoginViewModel: ObservableObject {
    
    //Login Form State
    @Published public var form = LoginFormState()
    
    //Login UI State
    @Published public var uiState: LoginUiState = .idle

    private let coordinator: AuthCoordinatorViewModel

    public init(coordinator: AuthCoordinatorViewModel) {
        self.coordinator = coordinator
    }

    public func login() async {
        guard form.isValid else {
            uiState = .error("Email and password are required")
            return
        }

        uiState = .loading

        do {
            // TODO: call auth repository
            try await Task.sleep(nanoseconds: 1_000_000_000)

            coordinator.loginSucceeded(
                needsEmailVerification: true,
                needsPhoneVerification: false
            )
        } catch {
            uiState = .error("Login failed")
        }

        uiState = .idle
    }

    public func goToSignup() {
        coordinator.goToSignup()
    }

    public func goToForgotPassword() {
        coordinator.goToForgotPassword()
    }
}
