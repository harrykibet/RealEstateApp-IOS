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
    
    // MARK: - UI Roles
    public let onSurface: Color
    public let outline: Color
    public let disabled: Color
    
    // MARK: - States
    public let success: Color
    public let error: Color
    public let warning: Color
    public let info: Color
    
    // MARK: - UI FeedBack
    public let progressFill: Color
    public let progressBackground: Color
    
    public init(
        primary: Color,
        onPrimary: Color,
        secondary: Color,
        onSecondary: Color,
        background: Color,
        surface: Color,
        surfaceVariant: Color,
        textPrimary: Color,
        textSecondary: Color,
        textDisabled: Color,
        onSurface: Color,
        outline: Color,
        disabled: Color,
        success: Color,
        error: Color,
        warning: Color,
        info: Color,
        progressBackground: Color,
        progressFill: Color
    ) {
        self.primary = primary
        self.onPrimary = onPrimary
        self.secondary = secondary
        self.onSecondary = onSecondary
        self.background = background
        self.surface = surface
        self.surfaceVariant = surfaceVariant
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textDisabled = textDisabled
        self.onSurface = onSurface
        self.outline = outline
        self.disabled = disabled
        self.success = success
        self.error = error
        self.warning = warning
        self.info = info
        self.progressBackground = progressBackground
        self.progressFill = progressFill
    }
}

extension SemanticColors {
    func progressFill(for style: EstatiaProgressStyle) -> Color {
        switch style {
        case .primary: return progressFill
        case .success: return success
        case .error: return error
        case .warning: return warning
        }
    }
}
