//
//  ForgotPasswordUiState.swift
//  auth
//
//  Created by builder on 2/1/26.
//


public enum ForgotPasswordUiState {
    case idle
    case loading
    case submitting
    case emailSent
    case error(String)
    case success(String)
}

extension ForgotPasswordUiState {

    var isLoading: Bool {
        if case .submitting = self { return true }
        return false
    }

    var errorMessage: String? {
        if case let .error(message) = self {
            return message
        }
        return nil
    }
    
    var successMessage: String? {
        if case let .success(message) = self {
            return message
        }
        return nil
    }

    var isError: Bool {
        if case .error = self { return true }
        return false
    }

    var isSuccess: Bool {
        if case .emailSent = self { return true }
        return false
    }
}
