//
//  TextField.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.

import SwiftUI

public struct EstatiaTextField: View {
    
    @Binding private var text: String
    private let placeholder: String
    private let state: InputState
    
    @FocusState private var isFocused: Bool
    
    @Environment(\.theme) private var theme
    
    public var body: some View {
        VStack(alignment: .leading, spacing: InputTokens.spacing) {
            
            EstatiaInputField(
                text: $text,
                placeholder: placeholder
            )
            .focused($isFocused)
            .disabled(isDisabled)
            .padding(.horizontal, InputTokens.horizontalPadding)
            .padding(.vertical, InputTokens.verticalPadding)
            .background(backgroundColor)
            .overlay(border)
            .clipShape(RoundedRectangle(cornerRadius: InputTokens.cornerRadius))
            
            if case let .error(message) = state {
                EstatiaText(message, style: .caption)
                    .foregroundColor(theme.colors.error)
            }
        }
    }
}
