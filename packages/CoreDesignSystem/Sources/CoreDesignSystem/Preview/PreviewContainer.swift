//
//  ComponentPreviewWrapper.swift
//  CoreDesignSystem
//

import SwiftUI

public struct PreviewContainer<Content: View>: View {

    private let content: Content
    private let colorScheme: ColorScheme

    public init(
        colorScheme: ColorScheme = .light,
        @ViewBuilder content: () -> Content
    ) {
        self.colorScheme = colorScheme
        self.content = content()
    }

    public var body: some View {
        ThemeProvider {
            content
        }
        .environment(\.colorScheme, colorScheme)
    }
}
