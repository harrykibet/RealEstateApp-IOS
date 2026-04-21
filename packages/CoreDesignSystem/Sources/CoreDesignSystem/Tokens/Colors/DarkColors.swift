//
//  DarkColors.swift
//  CoreDesignSystem
//
//  Created by builder on 4/4/26.
//

import SwiftUI

public extension AppSemanticColors {
    
    @MainActor static let dark = AppSemanticColors(
        primary: ColorPalette.Blue.base,
        onPrimary: ColorPalette.Base.black,
        
        secondary: ColorPalette.Green.strong,
        onSecondary: ColorPalette.Base.black,
        
        background: ColorPalette.Base.black,
        surface: Color(hex: "#111827"),
        surfaceVariant: Color(hex: "#1F2937"),
        
        textPrimary: ColorPalette.Base.white,
        textSecondary: ColorPalette.Gray.medium,
        textDisabled: ColorPalette.Gray.secondary,
        
        onSurface: ColorPalette.Base.white,
        outline: ColorPalette.Gray.secondary,
        disabled: ColorPalette.Gray.medium,
        
        success: ColorPalette.Status.success,
        error: ColorPalette.Status.error,
        warning: ColorPalette.Status.warning,
        info: ColorPalette.Status.info,
        
        progressBackground: ColorPalette.Gray.secondary.opacity(0.35),
        progressFill: ColorPalette.Blue.base,
        
        separator: ColorPalette.Gray.medium
    )
}
