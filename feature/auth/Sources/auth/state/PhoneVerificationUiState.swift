//
//  PhoneVerificationUiState.swift
//  auth
//
//  Created by builder on 2/1/26.
//


public enum PhoneVerificationUiState {
    case idle
    case loading
    case sendingCode
    case codeSent
    case verifyingCode
    case verified
    case error(String)
}

extension PhoneVerificationUiState {

    var isLoading: Bool {
        switch self {
        case .sendingCode, .verifyingCode:
            return true
        default:
            return false
        }
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

    var isVerified: Bool {
        if case .verified = self { return true }
        return false
    }
}
