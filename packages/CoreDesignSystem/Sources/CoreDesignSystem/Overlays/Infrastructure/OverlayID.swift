//
//  OverlayID.swift
//  CoreDesignSystem
//
//  Created by builder on 5/7/26.
//

import Foundation

public struct OverlayID:
    Hashable,
    Sendable,
    Identifiable,
    CustomStringConvertible
{
    
    public let rawValue: UUID
    
    public var id: UUID {
        rawValue
    }
    
    public var description: String {
        rawValue.uuidString
    }
    
    public init() {
        self.rawValue = UUID()
    }
    
    public init(rawValue: UUID) {
        self.rawValue = rawValue
    }
}
