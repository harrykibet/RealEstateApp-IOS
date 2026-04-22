//
//  EstatiaListItem.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaListItem<Leading: View, Content: View, Trailing: View>: View {
    
    @Environment(\.theme) private var theme
    
    private let style: EstatiaListItemStyle
    private let leading: Leading
    private let content: Content
    private let trailing: Trailing
    
    public init(
        style: EstatiaListItemStyle = .standard,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder content: () -> Content,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.style = style
        self.leading = leading()
        self.content = content()
        self.trailing = trailing()
    }
    
    public var body: some View {
        HStack(spacing: theme.dimensions.spacing.md) {
            
            leading
            
            content
            
            Spacer(minLength: 0)
            
            if style.showsChevron {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            
            trailing
        }
        .padding(.vertical, style.verticalPadding)
        .foregroundStyle(style.isDestructive ? theme.colors.error : theme.colors.textPrimary)
    }
}
