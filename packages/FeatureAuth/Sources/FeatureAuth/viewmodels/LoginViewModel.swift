//
//  LoginViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//


import Foundation
import CoreAppData

@MainActor
public final class LoginViewModel: ObservableObject {
    
    // MARK: - Published State
    
    @Published public var form = LoginFormState()
    
    @Published public private(set) var uiState: LoginUiState = .idle
    
    // MARK: - Dependencies
    
    private let authRepository: AuthRepository
    
    // MARK: - Init
    
    public init(
        authRepository: AuthRepository
    ) {
        self.authRepository = authRepository
    }
    
    // MARK: - Login
    
    public func login() async -> LoginResult? {
        
        guard form.isValid else {
            uiState = .error("Email and password are required")
            return nil
        }
        
        uiState = .loading
        
        defer {
            if case .loading = uiState {
                uiState = .idle
            }
        }
        
        do {
            
            let result = try await authRepository.signIn(
                email: form.email,
                password: form.password
            )
            
            switch result {
                
            case .authenticated:
                return .authenticated
                
            case .requiresEmailVerification(let email):
                return .requiresEmailVerification(email: email)
                
            case .requiresPhoneVerification(let phone):
                return .requiresPhoneVerification(phone: phone)
            }
            
        } catch {
            
            uiState = .error(
                error.localizedDescription
            )
            
            return nil
        }
    }
}
