//
//  EmailVerificationViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import Foundation

@MainActor
public final class EmailVerificationViewModel: ObservableObject {

    @Published public var isLoading: Bool = false
    @Published public var message: String?

    private let coordinator: AuthCoordinatorViewModel

    public init(coordinator: AuthCoordinatorViewModel) {
        self.coordinator = coordinator
    }

    public func resendEmail() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 800_000_000)
        message = "Verification email resent"
        isLoading = false
    }

    public func emailVerified() {
        coordinator.emailVerified()
    }
}
