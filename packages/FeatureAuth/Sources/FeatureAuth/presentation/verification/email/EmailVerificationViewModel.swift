//
//  EmailVerificationViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import Foundation
import CoreAppData
import CoreModel

@MainActor
public final class EmailVerificationViewModel:
    ObservableObject {

    // MARK: - State

    @Published
    public var uiState: EmailVerificationUiState = .idle

    // MARK: - Dependencies

    private let authRepository: AuthRepository

    // MARK: - Init

    public init(
        authRepository: AuthRepository
    ) {
        self.authRepository = authRepository
    }

    // MARK: - Resend Verification

    public func resendEmail() async {

        uiState = .loading

        do {

            try await authRepository
                .sendEmailVerification()

            uiState = .waitingForVerification(
                "Verification email sent"
            )

        } catch {

            uiState = .error(
                error.localizedDescription
            )
        }
    }

    // MARK: - Refresh Session

    public func refreshSession() async throws -> AuthSession {

        uiState = .loading

        defer {

            if case .loading = uiState {
                uiState = .idle
            }
        }

        do {

            return try await authRepository
                .currentSession()

        } catch {

            uiState = .error(
                error.localizedDescription
            )

            throw error
        }
    }
}
