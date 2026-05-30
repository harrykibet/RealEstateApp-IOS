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
    
    public func resendEmail() async {
        
        uiState = .loading
        
        do {
            
            try await authRepository
                .sendEmailVerification()
            
            uiState = .isLoading(
                "Verification email sent"
            )
            
        } catch {
            
            uiState = .error(
                error.localizedDescription
            )
        }
    }
}
