//
//  AuthCoordinatorViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//


import Foundation
import SwiftUI

@MainActor
public final class AuthCoordinatorViewModel: ObservableObject {
    @Published public var flow: AuthFlow = .login
    @Published public var isAuthenticated: Bool = false
    
    public init() {}
    
    public func goToLogin() { flow = .login }
    public func goToSignup() { flow = .signup }
    public func goToForgotPassword() { flow = .forgotPassword }
    public func goToPhoneVerification() { flow = .phoneVerification }
    public func goToEmailVerification() { flow = .emailVerification }
    
    // Success helpers
    public func loginSucceeded(needsEmailVerification: Bool, needsPhoneVerification: Bool) {
        if needsEmailVerification {
            flow = .emailVerification
        } else if needsPhoneVerification {
            flow = .phoneVerification
        } else {
            isAuthenticated = true
            // maybe navigate to main app screen
        }
    }
    
    public func signupSucceeded() {
        // after signup, often you want email verification first
        flow = .emailVerification
    }
    
    public func phoneVerified() {
        // move to next step or mark as authenticated
        isAuthenticated = true
    }
    
    public func emailVerified() {
        isAuthenticated = true
    }
}
