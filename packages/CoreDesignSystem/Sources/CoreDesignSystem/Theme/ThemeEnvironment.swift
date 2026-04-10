//
//  ThemeEnvironment.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

@MainActor
private struct ThemeEnvironmentKey: @MainActor EnvironmentKey {
    @MainActor static let defaultValue: AppTheme = EstatiaTheme(colors: .light)
}

@MainActor
public extension EnvironmentValues {
    
    var theme: AppTheme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

@MainActor
public struct ThemeProvider<Content: View>: View {
    
    private let content: Content
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .environment(\.theme, currentTheme)
    }
    
    private var currentTheme: AppTheme {
        switch colorScheme {
        case .dark:
            return EstatiaTheme(colors: .dark)
        default:
            return EstatiaTheme(colors: .light)
        }
    }
}

