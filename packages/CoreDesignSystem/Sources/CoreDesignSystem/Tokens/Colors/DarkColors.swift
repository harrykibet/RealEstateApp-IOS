//
//  DarkColors.swift
//  CoreDesignSystem
//
//  Created by builder on 4/4/26.
//

import SwiftUI

public extension SemanticColors {
    
    static let dark = SemanticColors(
        primary: ColorPalette.blue500,
        onPrimary: ColorPalette.black,
        
        secondary: ColorPalette.emerald600,
        onSecondary: ColorPalette.black,
        
        background: ColorPalette.black,
        surface: Color(hex: "#111827"),
        surfaceVariant: Color(hex: "#1F2937"),
        
        textPrimary: ColorPalette.white,
        textSecondary: ColorPalette.gray400,
        textDisabled: ColorPalette.gray500,
        
        success: ColorPalette.green500,
        error: ColorPalette.red500,
        warning: ColorPalette.yellow500,
        info: ColorPalette.blue500
    )
}
