//
//  EstatiaInputContainer.swift
//  CoreDesignSystem
//
//  Created by builder on 4/26/26.
//

import SwiftUI


struct EstatiaInputContainer<Content: View>: View {
    
    let state: InputState
    let isFocused: Bool
    let content: Content
    
    @Environment(\.theme) private var theme
    
    init(
        state: InputState,
        isFocused: Bool,
        @ViewBuilder content: () -> Content
    ) {
        self.state = state
        self.isFocused = isFocused
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(.horizontal, InputTokens.horizontalPadding)
            .padding(.vertical, InputTokens.verticalPadding)
            .background(backgroundColor)
            .overlay(border)
            .clipShape(RoundedRectangle(cornerRadius: InputTokens.cornerRadius))
    }
}

private extension EstatiaInputContainer {
    
    var backgroundColor: Color {
        switch state {
        case .disabled:
            return theme.colors.surfaceVariant
        default:
            return theme.colors.surface
        }
    }
    
    var borderColor: Color {
        if case .error = state {
            return theme.colors.error
        }
        
        if isFocused {
            return theme.colors.primary
        }
        
        return theme.colors.surfaceVariant
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: InputTokens.cornerRadius)
            .stroke(borderColor, lineWidth: InputTokens.borderWidth)
    }
}
