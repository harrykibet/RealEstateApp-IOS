//
//  ForgotPasswordViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import Foundation
import CoreAppData

@MainActor
public final class ForgotPasswordViewModel:
ObservableObject {

    // MARK: - Form State

    @Published
    public var form = ForgotPasswordFormState()

    // MARK: - UI State

    @Published
    public var uiState: ForgotPasswordUiState = .idle

    // MARK: - Dependencies

    private let authRepository: AuthRepository

    // MARK: - Init

    public init(
        authRepository: AuthRepository
    ) {
        self.authRepository = authRepository
    }
}

extension ForgotPasswordViewModel {

    public func sendResetLink() async {

        guard form.isValid else {

            uiState = .error(
                "Email is required"
            )

            return
        }

        uiState = .loading

        do {

            try await authRepository
                .sendPasswordResetEmail(
                    email: form.email
                )

            uiState = .success(
                "Password reset link sent"
            )

        } catch {

            uiState = .error(
                error.localizedDescription
            )
        }
    }
}
