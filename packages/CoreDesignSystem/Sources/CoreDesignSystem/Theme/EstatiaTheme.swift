//
//  ThemeProvider.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

public struct EstatiaTheme: AppTheme {

    public let colors: SemanticColors
    public let typography: Typography

    public init(
        colors: SemanticColors,
        typography: Typography = .estatia
    ) {
        self.colors = colors
        self.typography = typography
    }
}
