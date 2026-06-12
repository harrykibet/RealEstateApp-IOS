//
//  PhoneVerificationFormState.swift
//  FeatureAuth
//
//  Created by builder on 5/30/26.
//


import Foundation

public struct PhoneVerificationFormState:
Sendable {

    public var code: String = ""

    public init() { }

    public var isValid: Bool {
        code.count >= 4
    }
}