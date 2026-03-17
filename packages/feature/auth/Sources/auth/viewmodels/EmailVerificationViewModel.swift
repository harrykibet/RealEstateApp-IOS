//
//  EmailVerificationViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import Foundation

@MainActor
public final class EmailVerificationViewModel: ObservableObject {

    // UI State
    @Published public var uiState: EmailVerificationUiState = .idle

    private let coordinator: AuthCoordinatorViewModel

    public init(coordinator: AuthCoordinatorViewModel) {
        self.coordinator = coordinator
    }

    public func resendEmail() async {
        uiState = .loading
        try? await Task.sleep(nanoseconds: 800_000_000)
        uiState = .error("Verification email resent")
        uiState = .idle
    }

    public func emailVerified() {
        coordinator.emailVerified()
    }
}
