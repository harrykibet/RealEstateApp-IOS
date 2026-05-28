//
//  AuthenticationResult.swift
//  FeatureAuth
//
//  Created by builder on 5/24/26.
//


public enum AuthenticationResult: Sendable, Equatable {
    
    case authenticated
    
    case requiresEmailVerification(email: String)
    
    case requiresPhoneVerification(phone: String)
}
