//
//  ForgotPasswordViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import Foundation

@MainActor
public final class ForgotPasswordViewModel: ObservableObject {

    // UI State
    @Published public var uiState: ForgotPasswordUiState = .idle
    
    // Email
    @Published public var email: String = ""

    private let coordinator: AuthCoordinatorViewModel

    public init(coordinator: AuthCoordinatorViewModel) {
        self.coordinator = coordinator
    }

    public func sendResetLink() async {
        guard !email.isEmpty else {
            uiState = .error("Email is required")
            return
        }

        uiState = .loading
        try? await Task.sleep(nanoseconds: 800_000_000)

        uiState = .success("Password reset link sent")
        uiState = .idle
    }

    public func backToLogin() {
        coordinator.goToLogin()
    }
}
