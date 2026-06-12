//
//  ForgotPasswordFormState.swift
//  FeatureAuth
//
//  Created by builder on 5/30/26.
//


public struct ForgotPasswordFormState: Sendable {

    public var email: String = ""

    public init() { }

    public var isValid: Bool {
        !email.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }
}