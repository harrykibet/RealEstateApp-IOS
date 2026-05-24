//
//  LoginResult.swift
//  FeatureAuth
//
//  Created by builder on 5/24/26.
//


public enum LoginResult: Sendable, Equatable {
    
    case authenticated
    
    case requiresEmailVerification(email: String)
    
    case requiresPhoneVerification(phone: String)
}