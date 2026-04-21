//
//  EstatiaListItem.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaListItem<Leading: View, Content: View, Trailing: View>: View {
    
    let leading: Leading
    let content: Content
    let trailing: Trailing
    
    @Environment(\.theme) private var theme
    
    public init(
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder content: () -> Content,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.leading = leading()
        self.content = content()
        self.trailing = trailing()
    }
    
    public var body: some View {
        HStack(spacing: theme.dimensions.spacing.md) {
            leading
            content
            Spacer(minLength: 0)
            trailing
        }
        .padding(.vertical, theme.dimensions.spacing.sm)
    }
}
