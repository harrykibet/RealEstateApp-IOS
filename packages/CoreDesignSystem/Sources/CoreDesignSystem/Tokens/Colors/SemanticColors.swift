//
//  SemanticColors.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

public struct SemanticColors {
    
    // MARK: - Core
    public let primary: Color
    public let onPrimary: Color
    
    public let secondary: Color
    public let onSecondary: Color
    
    // MARK: - Surfaces
    public let background: Color
    public let surface: Color
    public let surfaceVariant: Color
    
    // MARK: - Text
    public let textPrimary: Color
    public let textSecondary: Color
    public let textDisabled: Color
    
    // MARK: - States
    public let success: Color
    public let error: Color
    public let warning: Color
    public let info: Color
}

import SwiftUI

public extension SemanticColors {
    
    static let light = SemanticColors(
        primary: ColorPalette.blue900,
        onPrimary: ColorPalette.white,
        
        secondary: ColorPalette.emerald500,
        onSecondary: ColorPalette.white,
        
        background: ColorPalette.white,
        surface: ColorPalette.gray50,
        surfaceVariant: ColorPalette.gray100,
        
        textPrimary: ColorPalette.gray900,
        textSecondary: ColorPalette.gray500,
        textDisabled: ColorPalette.gray400,
        
        success: ColorPalette.green500,
        error: ColorPalette.red500,
        warning: ColorPalette.yellow500,
        info: ColorPalette.blue500
    )
}
