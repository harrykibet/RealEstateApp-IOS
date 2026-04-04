//
//  LightColors.swift
//  CoreDesignSystem
//
//  Created by builder on 4/4/26.
//

import SwiftUI

public extension SemanticColors {
    
    static let light = SemanticColors(
        primary: ColorPalette.Blue.deep,
        primaryForeground: ColorPalette.Base.white,
        
        secondary: ColorPalette.Green.base,
        secondaryForeground: ColorPalette.Base.white,
        
        background: ColorPalette.Base.white,
        surface: ColorPalette.Gray.ultraLight,
        surfaceMuted: ColorPalette.Gray.light,
        
        textPrimary: ColorPalette.Gray.primary,
        textSecondary: ColorPalette.Gray.secondary,
        textDisabled: ColorPalette.Gray.medium,
        
        success: ColorPalette.Status.success,
        error: ColorPalette.Status.error,
        warning: ColorPalette.Status.warning,
        info: ColorPalette.Status.info
    )
}
