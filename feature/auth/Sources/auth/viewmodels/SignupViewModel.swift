//
//  SignupViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//


import Foundation

@MainActor
public final class SignupViewModel: ObservableObject {

    @Published public var email = ""
    @Published public var password = ""
    @Published public var confirmPassword = ""

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    private let coordinator: AuthCoordinatorViewModel

    public init(coordinator: AuthCoordinatorViewModel) {
        self.coordinator = coordinator
    }

    public func signup() async {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            // TODO: signup API
            try await Task.sleep(nanoseconds: 1_000_000_000)
            coordinator.signupSucceeded()
        } catch {
            errorMessage = "Signup failed"
        }

        isLoading = false
    }

    public func backToLogin() {
        coordinator.goToLogin()
    }
}
