//
//  PhoneVerificationViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import Foundation

@MainActor
public final class PhoneVerificationViewModel: ObservableObject {

    // OTP
    @Published public var code: String = ""
    
    //UI State
    @Published public var uiState: PhoneVerificationUiState = .idle

    private let coordinator: AuthCoordinatorViewModel

    public init(coordinator: AuthCoordinatorViewModel) {
        self.coordinator = coordinator
    }
    
    public func sendCode() async {
        
    }

    public func verifyCode() async {
        guard code.count >= 4 else {
            uiState = .error("Invalid verification code")
            return
        }

        uiState = .loading

        try? await Task.sleep(nanoseconds: 800_000_000)

        coordinator.phoneVerified()
        uiState = .idle
    }

    public func verifyEmailInstead() {
        coordinator.goToEmailVerification()
    }
}
