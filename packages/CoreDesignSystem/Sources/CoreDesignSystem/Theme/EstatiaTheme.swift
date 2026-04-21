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

public extension EstatiaTheme {
    
    static func resolve(_ variant: EstatiaThemeVariant) -> EstatiaTheme {
        switch variant {
        case .light:
            return EstatiaTheme(
                colors: .light,
                dimensions: .estatia,
                typography: .estatia
            )
            
        case .dark:
            return EstatiaTheme(
                colors: .dark,
                dimensions: .estatia,
                typography: .estatia
            )
        }
    }
}
