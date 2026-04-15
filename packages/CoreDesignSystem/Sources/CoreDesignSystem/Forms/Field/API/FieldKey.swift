//
//  FieldKey.swift
//  CoreDesignSystem
//
//  Created by builder on 4/15/26.
//


//
//  FieldKey.swift
//  CoreDesignSystem
//

import Foundation

public struct FieldKey: Hashable, Equatable {
    
    public let rawValue: String
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}