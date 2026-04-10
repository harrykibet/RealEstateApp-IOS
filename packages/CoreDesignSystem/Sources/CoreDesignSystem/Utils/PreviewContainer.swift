//
//  ComponentPreviewWrapper.swift
//  CoreDesignSystem
//
//  Created by builder on 4/5/26.
//

import SwiftUI

@available(iOS 13.0, *)
struct PreviewContainer<Content: View>: View {
    
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
        ThemeProvider {
            content.padding()
        }
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
    }
}
