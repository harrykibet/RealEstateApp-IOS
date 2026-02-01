//
//  SignupFormState.swift
//  auth
//
//  Created by builder on 2/1/26.
//


public struct SignupFormState {
    public var name: String = ""
    public var email: String = ""
    public var phone: String = ""
    public var password: String = ""
    public var confirmPassword: String = ""

    // MARK: - Validation

    public var isEmailValid: Bool {
        email.contains("@") && email.contains(".")
    }

    public var isPasswordValid: Bool {
        password.count >= 8
    }

    public var doPasswordsMatch: Bool {
        password == confirmPassword
    }

    public var isFormValid: Bool {
        !name.isEmpty &&
        isEmailValid &&
        isPasswordValid &&
        doPasswordsMatch
    }
}
