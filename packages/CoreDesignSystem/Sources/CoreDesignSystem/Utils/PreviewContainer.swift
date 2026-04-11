//
//  ComponentPreviewWrapper.swift
//  CoreDesignSystem
//

import SwiftUI

@available(iOS 13.0, *)
public struct PreviewContainer<Content: View>: View {

    private let isDarkMode: Bool
    private let content: Content

    public init(
        isDarkMode: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.isDarkMode = isDarkMode
        self.content = content()
    }

    public var body: some View {
        themedContent
    }
}

@available(iOS 13.0, *)
private extension PreviewContainer {

    var themedContent: some View {
        ThemeProvider {
            content
        }
        .environment(\.colorScheme, colorScheme)
    }

    var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }
}
