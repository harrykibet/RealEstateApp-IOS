//
//  SignupViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//


import Foundation

@MainActor
public final class SignupViewModel: ObservableObject {
    
    //Sign Up Form State
    @Published public var form = SignupFormState()
    
    // Sign Up UI State
    @Published public var uiState: SignupUiState = .idle

    private let coordinator: AuthCoordinatorViewModel

    public init(coordinator: AuthCoordinatorViewModel) {
        self.coordinator = coordinator
    }

    public func signup() async {
        guard form.isFormValid else {
            uiState = .error("Passwords do not match")
            return
        }

        uiState = .loading

        do {
            // TODO: signup API
            try await Task.sleep(nanoseconds: 1_000_000_000)
            coordinator.signupSucceeded()
        } catch {
            uiState = .error("Signup failed")
        }

        uiState = .idle
    }

    public func backToLogin() {
        coordinator.goToLogin()
    }
}
