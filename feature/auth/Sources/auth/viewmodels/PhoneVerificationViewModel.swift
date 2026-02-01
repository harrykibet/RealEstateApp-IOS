//
//  PhoneVerificationViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import Foundation

@MainActor
public final class PhoneVerificationViewModel: ObservableObject {

    @Published public var code: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    private let coordinator: AuthCoordinatorViewModel

    public init(coordinator: AuthCoordinatorViewModel) {
        self.coordinator = coordinator
    }
    
    public func sendCode() async {
        
    }

    public func verifyCode() async {
        guard code.count >= 4 else {
            errorMessage = "Invalid verification code"
            return
        }

        isLoading = true
        errorMessage = nil

        try? await Task.sleep(nanoseconds: 800_000_000)

        coordinator.phoneVerified()
        isLoading = false
    }

    public func verifyEmailInstead() {
        coordinator.goToEmailVerification()
    }
}
