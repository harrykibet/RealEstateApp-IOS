//
//  SecurityConfig.swift
//  model
//
//  Created by builder on 5/3/25.
//


import Foundation

public struct SecurityConfig: Codable, Equatable {
    public var encryptionAlgorithm: String
    public var keyAlias: String

    public init(encryptionAlgorithm: String, keyAlias: String) {
        self.encryptionAlgorithm = encryptionAlgorithm
        self.keyAlias = keyAlias
    }
}
