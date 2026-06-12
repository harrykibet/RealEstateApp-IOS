//
//  SignupUiState.swift
//  auth
//
//  Created by builder on 2/1/26.
//


public enum SignupUiState {
    case idle
    case loading
    case success
    case error(String)
}

extension SignupUiState {
    var isIdle: Bool {
        if case .idle = self {
            return true
        }
        return false
    }
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var errorMessage: String? {
        if case let .error(message) = self {
            return message
        }
        return nil
    }

    var isError: Bool {
        if case .error = self { return true }
        return false
    }
}
