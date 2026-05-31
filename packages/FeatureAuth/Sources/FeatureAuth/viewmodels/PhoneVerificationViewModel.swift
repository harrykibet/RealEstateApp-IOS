//
//  PhoneVerificationViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import Foundation
import CoreAppData
import CoreModel

@MainActor
public final class PhoneVerificationViewModel:
    ObservableObject {

    // MARK: - Form

    @Published
    public var form = PhoneVerificationFormState()

    // MARK: - UI State

    @Published
    public private(set) var uiState:
        PhoneVerificationUiState = .idle

    // MARK: - Dependencies

    private let authRepository: AuthRepository

    // MARK: - Init

    public init(
        authRepository: AuthRepository
    ) {
        self.authRepository = authRepository
    }

    // MARK: - Send Code

    public func sendCode() async {

        uiState = .loading

        do {

            try await authRepository
                .sendPhoneVerificationCode()

            uiState = .codeSent(
                "Verification code sent"
            )

        } catch {

            uiState = .error(
                error.localizedDescription
            )
        }
    }

    // MARK: - Verify Code

    public func verifyCode() async -> AuthSession? {

        guard form.isValid else {

            uiState = .error(
                "Invalid verification code"
            )

            return nil
        }

        uiState = .loading

        defer {

            if case .loading = uiState {
                uiState = .idle
            }
        }

        do {

            return try await authRepository
                .verifyPhoneCode(
                    form.code
                )

        } catch {

            uiState = .error(
                error.localizedDescription
            )

            return nil
        }
    }
}
