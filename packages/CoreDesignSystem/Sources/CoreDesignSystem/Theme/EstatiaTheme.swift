//
//  ThemeProvider.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

public struct EstatiaTheme: AppTheme {

    public let colors: AppSemanticColors
    public let typography: AppTypography

    public init(
        colors: AppSemanticColors,
        typography: AppTypography = .estatia
    ) {
        self.colors = colors
        self.typography = typography
    }
}
