//
//  File.swift
//  CoreSecurity
//
//  Created by builder on 4/28/26.
//

import CryptoKit
import Foundation

public func sha256(_ string: String) -> String {
    let data = Data(string.utf8)
    let hash = SHA256.hash(data: data)
    return hash.compactMap { String(format: "%02x", $0) }.joined()
}
