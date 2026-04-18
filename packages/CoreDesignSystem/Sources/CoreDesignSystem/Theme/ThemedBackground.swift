//
//  ThemedBackground.swift
//  CoreDesignSystem
//
//  Created by builder on 4/11/26.
//

import SwiftUI

@MainActor
public struct ThemedBackground<Content: View>: View {

    @Environment(\.theme) private var theme
    
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ZStack {
            theme.colors.background
                .ignoresSafeArea()

            content
        }
    }
}
