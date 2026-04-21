//
//  LightColors.swift
//  CoreDesignSystem
//
//  Created by builder on 4/4/26.
//

import SwiftUI

public extension SemanticColors {
    
    @MainActor static let light = SemanticColors(
        primary: ColorPalette.Blue.deep,
        onPrimary: ColorPalette.Base.white,
        
        secondary: ColorPalette.Green.base,
        onSecondary: ColorPalette.Base.white,
        
        background: ColorPalette.Base.white,
        surface: ColorPalette.Gray.ultraLight,
        surfaceVariant: ColorPalette.Gray.light,
        
        textPrimary: ColorPalette.Gray.primary,
        textSecondary: ColorPalette.Gray.secondary,
        textDisabled: ColorPalette.Gray.medium,
        
        onSurface: ColorPalette.Gray.primary,
        outline: ColorPalette.Gray.light,
        disabled: ColorPalette.Gray.medium,
        
        success: ColorPalette.Status.success,
        error: ColorPalette.Status.error,
        warning: ColorPalette.Status.warning,
        info: ColorPalette.Status.info,
        
        progressBackground: ColorPalette.Gray.secondary.opacity(0.25),
        progressFill: ColorPalette.Blue.base,
        
        separator: ColorPalette.Gray.light
    )
}
