//
//  LightColors.swift
//  CoreDesignSystem
//
//  Created by builder on 4/4/26.
//

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
