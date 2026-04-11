//
//  ComponentPreviewWrapper.swift
//  CoreDesignSystem
//

import SwiftUI

@MainActor
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
            ThemedBackground {
                content
            }
        }
        .environment(\.colorScheme, colorScheme)
    }
}
