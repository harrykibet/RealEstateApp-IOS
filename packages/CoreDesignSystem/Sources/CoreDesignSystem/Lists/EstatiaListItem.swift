//
//  EstatiaListItem.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

public struct EstatiaListItem<Leading: View, Content: View, Trailing: View>: View {
    
    let leading: Leading
    let content: Content
    let trailing: Trailing
    
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
        HStack(spacing: theme.spacing.md) {
            leading
            content
            Spacer(minLength: 0)
            trailing
        }
        .padding(.vertical, theme.spacing.sm)
    }
}
