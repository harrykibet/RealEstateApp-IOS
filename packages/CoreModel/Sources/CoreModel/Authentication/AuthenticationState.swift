//
//  AuthenticationState.swift
//  CoreModel
//
//  Created by builder on 5/28/26.
//


import Foundation

public enum AuthenticationState: Sendable, Equatable {
    
    case unauthenticated
    
    case authenticated(User)
    
    case requiresEmailVerification(User)
    
    case requiresPhoneVerification(User)
}