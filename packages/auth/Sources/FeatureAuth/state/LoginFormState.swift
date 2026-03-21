//
//  LoginFormState.swift
//  auth
//
//  Created by builder on 1/31/26.
//

public struct LoginFormState {
    public var email: String = ""
    public var password: String = ""
    public var isSecure: Bool = true
    
    public var isValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
}
