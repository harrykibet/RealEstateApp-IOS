//
//  ThemeProvider.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

public struct DefaultThemeProvider: ThemeProviding {
    public let colors: SemanticColors
    
    public init(colors: SemanticColors) {
        self.colors = colors
    }
}
