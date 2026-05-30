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
    
    public func sendCode() async {
        
        uiState = .loading
        
        do {
            
            try await authRepository
                .sendPhoneVerificationCode()
            
            uiState = .success(
                "Verification code sent"
            )
            
        } catch {
            
            uiState = .error(
                error.localizedDescription
            )
        }
    }
}
