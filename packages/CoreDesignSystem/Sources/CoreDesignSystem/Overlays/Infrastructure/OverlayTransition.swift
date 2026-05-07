//
//  OverlayTransition.swift
//  CoreDesignSystem
//
//  Created by builder on 5/7/26.
//

import Foundation

public enum OverlayTransition:
    Sendable,
    Equatable
{
    
    case opacity
    
    case scale
    
    case slideFromBottom
    
    case slideFromTop
    
    case slideFromLeading
    
    case slideFromTrailing
    
    case custom(
        insertion: String,
        removal: String
    )
}
