//
//  OverlayPriority.swift
//  CoreDesignSystem
//
//  Created by builder on 5/7/26.
//

import Foundation

public enum OverlayPriority:
    Int,
    CaseIterable,
    Comparable,
    Sendable
{
    
    case background = 0
    
    case toast = 100
    
    case sheet = 200
    
    case dialog = 300
    
    case modal = 400
    
    case critical = 1000
}

extension OverlayPriority {
    
    public static func < (
        lhs: OverlayPriority,
        rhs: OverlayPriority
    ) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
