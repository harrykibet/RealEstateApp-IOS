//
//  SearchField.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

@available(iOS 15.0, *)
public struct EstatiaSearchField: View {
    
    @Binding private var text: String
    private let placeholder: String
    
    @FocusState private var isFocused: Bool
    
    @Environment(\.theme) private var theme
    
    public init(
        text: Binding<String>,
        placeholder: String = "Search"
    ) {
        self._text = text
        self.placeholder = placeholder
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(theme.colors.textSecondary)
            
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .foregroundColor(theme.colors.textPrimary)
            
            if !text.isEmpty {
                Button(action: clearText) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(theme.colors.textSecondary)
                }
            }
        }
        .padding(.horizontal, InputTokens.horizontalPadding)
        .padding(.vertical, InputTokens.verticalPadding)
        .background(theme.colors.surface)
        .overlay(border)
        .clipShape(RoundedRectangle(cornerRadius: InputTokens.cornerRadius))
    }
    
    private func clearText() {
        text = ""
    }
}

// MARK: - Styling

@available(iOS 15.0, *)
private extension EstatiaSearchField {
    
    var border: some View {
        RoundedRectangle(cornerRadius: InputTokens.cornerRadius)
            .stroke(
                isFocused ? theme.colors.primary : theme.colors.surfaceVariant,
                lineWidth: InputTokens.borderWidth
            )
    }
}

