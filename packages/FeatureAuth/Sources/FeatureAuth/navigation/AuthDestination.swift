//
//  AuthDestination.swift
//  FeatureAuth
//
//  Created by builder on 5/24/26.
//


public enum AuthDestination: Hashable, Sendable {
    case signup
    case forgotPassword
    case phoneVerification(phone: String)
    case emailVerification(email: String)
}