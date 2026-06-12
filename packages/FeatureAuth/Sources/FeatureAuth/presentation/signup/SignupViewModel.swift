//
//  SignupViewModel.swift
//  FeatureAuth
//
//  Created by builder on 1/31/26.
//

import Foundation
import CoreAppData
import CoreModel

@MainActor
public final class SignupViewModel: ObservableObject {

    // MARK: - Form State

    @Published
    public var form = SignupFormState()

    // MARK: - UI State

    @Published
    public private(set) var uiState: SignupUiState = .idle

    // MARK: - Dependencies

    private let authRepository: AuthRepository

    // MARK: - Init

    public init(
        authRepository: AuthRepository
    ) {
        self.authRepository = authRepository
    }

    // MARK: - Signup

    public func signup() async -> AuthSession? {

        guard validateForm() else {
            return nil
        }

        uiState = .loading

        defer {

            if case .loading = uiState {
                uiState = .idle
            }
        }

        do {

            let session = try await authRepository.signUp(
                email: form.email,
                password: form.password,
                displayName: form.name
            )

            return session

        } catch {

            uiState = .error(
                error.localizedDescription
            )

            return nil
        }
    }
}

extension SignupViewModel {

    private func validateForm() -> Bool {

        guard form.isFormValid else {

            uiState = .error(
                "Passwords do not match"
            )

            return false
        }

        return true
    }
}
