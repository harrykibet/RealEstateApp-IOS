//
//  LightColors.swift
//  CoreDesignSystem
//
//  Created by builder on 4/4/26.
//
//  Light theme semantic colors — mirrors Android LightDefaultColorScheme.

import SwiftUI

public extension AppSemanticColors {

    @MainActor static let light = AppSemanticColors(
        primary: ColorPalette.Blue.blue40,
        onPrimary: ColorPalette.Base.white,
        primaryContainer: ColorPalette.Blue.blue90,
        onPrimaryContainer: ColorPalette.Blue.blue10,

        secondary: ColorPalette.Slate.slate40,
        onSecondary: ColorPalette.Base.white,
        secondaryContainer: ColorPalette.Slate.slate90,
        onSecondaryContainer: ColorPalette.Slate.slate10,

        tertiary: ColorPalette.Orange.orange40,
        onTertiary: ColorPalette.Base.white,
        tertiaryContainer: ColorPalette.Orange.orange90,
        onTertiaryContainer: ColorPalette.Orange.orange10,

        error: ColorPalette.Red.red40,
        onError: ColorPalette.Base.white,
        errorContainer: ColorPalette.Red.red90,
        onErrorContainer: ColorPalette.Red.red10,

        background: ColorPalette.Slate.slate99,
        onBackground: ColorPalette.Slate.slate10,
        surface: ColorPalette.Slate.slate99,
        onSurface: ColorPalette.Slate.slate10,
        surfaceVariant: ColorPalette.Slate.slate90,
        onSurfaceVariant: ColorPalette.Slate.slate30,

        inverseSurface: ColorPalette.Slate.slate20,
        inverseOnSurface: ColorPalette.Slate.slate95,

        outline: ColorPalette.Slate.slate80,
        disabled: ColorPalette.Slate.slate60,

        textPrimary: ColorPalette.Slate.slate10,
        textSecondary: ColorPalette.Slate.slate40,
        textDisabled: ColorPalette.Slate.slate60,

        success: ColorPalette.Green.green40,
        warning: ColorPalette.Orange.orange40,
        info: ColorPalette.Blue.blue40,

        progressBackground: ColorPalette.Slate.slate40.opacity(0.25),
        progressFill: ColorPalette.Blue.blue40,
        separator: ColorPalette.Slate.slate80.opacity(0.5)
    )
}
