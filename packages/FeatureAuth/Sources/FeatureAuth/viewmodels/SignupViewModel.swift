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
    public var uiState: SignupUiState = .idle
    
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
            uiState = .idle
        }
        
        do {
            
            try await authRepository.signUp(
                email: form.email,
                password: form.password,
                displayName: form.name)
            
            try await Task.sleep(
                nanoseconds: 1_000_000_000
            )
            
            // Example outcome
            
            return status.requiresEmailVerification(
                email: form.email
            )
            
        } catch {
            
            uiState = .error(
                "Signup failed"
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
