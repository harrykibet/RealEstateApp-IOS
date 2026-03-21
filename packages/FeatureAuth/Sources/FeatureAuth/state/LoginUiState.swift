//
//  LoginUiState.swift
//  auth
//
//  Created by builder on 1/31/26.
//

public enum LoginUiState {
    case idle
    case loading
    case error(String)
}

extension LoginUiState {
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var isIdle: Bool {
        if case .idle = self {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case let .error(message) = self {
            return message
        }
        return nil
    }

    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
}
