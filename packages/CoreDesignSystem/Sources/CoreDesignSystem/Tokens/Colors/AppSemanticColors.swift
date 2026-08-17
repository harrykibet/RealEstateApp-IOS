//
//  AppSemanticColors.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//
//  Semantic color roles aligned with Android Material 3 color schemes
//  (LightDefaultColorScheme / DarkDefaultColorScheme).

import SwiftUI

public struct AppSemanticColors {

    // MARK: - Primary

    public let primary: Color
    public let onPrimary: Color
    public let primaryContainer: Color
    public let onPrimaryContainer: Color

    // MARK: - Secondary

    public let secondary: Color
    public let onSecondary: Color
    public let secondaryContainer: Color
    public let onSecondaryContainer: Color

    // MARK: - Tertiary

    public let tertiary: Color
    public let onTertiary: Color
    public let tertiaryContainer: Color
    public let onTertiaryContainer: Color

    // MARK: - Error

    public let error: Color
    public let onError: Color
    public let errorContainer: Color
    public let onErrorContainer: Color

    // MARK: - Surfaces

    public let background: Color
    public let onBackground: Color
    public let surface: Color
    public let onSurface: Color
    public let surfaceVariant: Color
    public let onSurfaceVariant: Color

    // MARK: - Inverse

    public let inverseSurface: Color
    public let inverseOnSurface: Color

    // MARK: - Outline & Disabled

    public let outline: Color
    public let disabled: Color

    // MARK: - Text (legacy aliases mapped to M3 roles)

    public let textPrimary: Color
    public let textSecondary: Color
    public let textDisabled: Color

    // MARK: - Status

    public let success: Color
    public let warning: Color
    public let info: Color

    // MARK: - Feedback

    public let progressFill: Color
    public let progressBackground: Color
    public let separator: Color

    public init(
        primary: Color,
        onPrimary: Color,
        primaryContainer: Color,
        onPrimaryContainer: Color,
        secondary: Color,
        onSecondary: Color,
        secondaryContainer: Color,
        onSecondaryContainer: Color,
        tertiary: Color,
        onTertiary: Color,
        tertiaryContainer: Color,
        onTertiaryContainer: Color,
        error: Color,
        onError: Color,
        errorContainer: Color,
        onErrorContainer: Color,
        background: Color,
        onBackground: Color,
        surface: Color,
        onSurface: Color,
        surfaceVariant: Color,
        onSurfaceVariant: Color,
        inverseSurface: Color,
        inverseOnSurface: Color,
        outline: Color,
        disabled: Color,
        textPrimary: Color,
        textSecondary: Color,
        textDisabled: Color,
        success: Color,
        warning: Color,
        info: Color,
        progressBackground: Color,
        progressFill: Color,
        separator: Color
    ) {
        self.primary = primary
        self.onPrimary = onPrimary
        self.primaryContainer = primaryContainer
        self.onPrimaryContainer = onPrimaryContainer
        self.secondary = secondary
        self.onSecondary = onSecondary
        self.secondaryContainer = secondaryContainer
        self.onSecondaryContainer = onSecondaryContainer
        self.tertiary = tertiary
        self.onTertiary = onTertiary
        self.tertiaryContainer = tertiaryContainer
        self.onTertiaryContainer = onTertiaryContainer
        self.error = error
        self.onError = onError
        self.errorContainer = errorContainer
        self.onErrorContainer = onErrorContainer
        self.background = background
        self.onBackground = onBackground
        self.surface = surface
        self.onSurface = onSurface
        self.surfaceVariant = surfaceVariant
        self.onSurfaceVariant = onSurfaceVariant
        self.inverseSurface = inverseSurface
        self.inverseOnSurface = inverseOnSurface
        self.outline = outline
        self.disabled = disabled
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textDisabled = textDisabled
        self.success = success
        self.warning = warning
        self.info = info
        self.progressBackground = progressBackground
        self.progressFill = progressFill
        self.separator = separator
    }
}

extension AppSemanticColors {
    func progressFill(for style: EstatiaProgressStyle) -> Color {
        switch style {
        case .primary: return progressFill
        case .success: return success
        case .error: return error
        case .warning: return warning
        }
    }
}
