//
//  DarkColors.swift
//  CoreDesignSystem
//
//  Created by builder on 4/4/26.
//

import SwiftUI

public extension AppSemanticColors {
    
    @MainActor static let dark = AppSemanticColors(
        // Use a lighter, desaturated primary for dark mode to increase legibility
        primary: Color(hex: "#D2E3FC"),
        onPrimary: ColorPalette.Base.black,
        
        secondary: ColorPalette.Green.strong,
        onSecondary: ColorPalette.Base.black,
        
        background: ColorPalette.Base.black,
        surface: Color(hex: "#202124"),
        surfaceVariant: Color(hex: "#202124"),
        
        textPrimary: ColorPalette.Base.white,
        textSecondary: ColorPalette.Gray.medium,
        textDisabled: ColorPalette.Gray.secondary,
        
        onSurface: ColorPalette.Base.white,
        outline: Color(hex: "#DADCE0"),
        disabled: ColorPalette.Gray.medium,
        
        success: ColorPalette.Status.success,
        error: ColorPalette.Status.error,
        warning: ColorPalette.Status.warning,
        info: ColorPalette.Status.info,
        
        progressBackground: ColorPalette.Gray.secondary.opacity(0.35),
        progressFill: Color(hex: "#D2E3FC"),
        
        separator: Color.white.opacity(0.06)
    )
}
