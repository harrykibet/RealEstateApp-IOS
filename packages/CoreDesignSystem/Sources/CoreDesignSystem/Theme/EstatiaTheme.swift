//
//  ThemeProvider.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

public struct EstatiaTheme: AppTheme {

    public let colors: AppSemanticColors
    public let typography: AppTypography
    public let dimensions: AppDimensions

    public init(
        colors: AppSemanticColors,
        dimensions: AppDimensions = .estatia,
        typography: AppTypography = .estatia
    ) {
        self.colors = colors
        self.dimensions = dimensions
        self.typography = typography
    }
}
