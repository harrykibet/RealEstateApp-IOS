//
//  DarkColors.swift
//  CoreDesignSystem
//
//  Created by builder on 4/4/26.
//

import SwiftUI

public extension SemanticColors {
    
    static let dark = SemanticColors(
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
        
        success: ColorPalette.Status.success,
        error: ColorPalette.Status.error,
        warning: ColorPalette.Status.warning,
        info: ColorPalette.Status.info
    )
}
