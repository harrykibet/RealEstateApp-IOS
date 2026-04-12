//
//  BaseCard.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

public struct EstatiaCard<Content: View>: View {
    
    private let style: CardStyle
    private let content: Content
    
    @Environment(\.theme) private var theme
    
    public init(
        style: CardStyle = .elevated,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(CardTokens.padding)
            .background(background)
            .overlay(borderOverlay)
            .clipShape(RoundedRectangle(cornerRadius: CardTokens.cornerRadius))
            .shadow(color: shadowColor, radius: shadowRadius)
    }
}

// MARK: - Styling
private extension EstatiaCard {
    
    var background: Color {
        switch style {
        case .elevated:
            return theme.colors.surface
        case .filled:
            return theme.colors.surfaceVariant
        case .outlined:
            return theme.colors.background
        }
    }
    
    var borderOverlay: some View {
        RoundedRectangle(cornerRadius: CardTokens.cornerRadius)
            .stroke(borderColor, lineWidth: borderWidth)
    }
    
    var borderColor: Color {
        switch style {
        case .outlined:
            return theme.colors.surfaceVariant
        default:
            return Color.clear
        }
    }
    
    var borderWidth: CGFloat {
        style == .outlined ? CardTokens.borderWidth : 0
    }
    
    var shadowColor: Color {
        style == .elevated ? Color.black.opacity(0.1) : Color.clear
    }
    
    var shadowRadius: CGFloat {
        style == .elevated ? CardTokens.elevation : 0
    }
}

#if DEBUG

#Preview("Card - Light") {
    Preview.light {
        cardPreviewContent
    }
}

#Preview("Card - Dark") {
    Preview.dark {
        cardPreviewContent
    }
}

// MARK: - Preview Content (isolated for reuse & compiler sanity)

private var cardPreviewContent: some View {
    VStack(spacing: 16) {
        
        EstatiaCard(style: .elevated) {
            Text("Elevated Card")
        }
        
        EstatiaCard(style: .filled) {
            Text("Filled Card")
        }
        
        EstatiaCard(style: .outlined) {
            Text("Outlined Card")
        }
    }
    .padding()
}

#endif
