//
//  ForgotPasswordViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import Foundation

@MainActor
public final class ForgotPasswordViewModel: ObservableObject {

    @Published public var email: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var successMessage: String?

    private let coordinator: AuthCoordinatorViewModel

    public init(coordinator: AuthCoordinatorViewModel) {
        self.coordinator = coordinator
    }

    public func sendResetLink() async {
        guard !email.isEmpty else {
            errorMessage = "Email is required"
            return
        }

        isLoading = true
        errorMessage = nil

        try? await Task.sleep(nanoseconds: 800_000_000)

        successMessage = "Password reset link sent"
        isLoading = false
    }

    public func backToLogin() {
        coordinator.goToLogin()
    }
}
