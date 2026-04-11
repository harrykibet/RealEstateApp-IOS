//
//  TextField.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

public struct EstatiaTextField: View {
    
    // MARK: - State
    
    @Binding private var text: String
    private let placeholder: String
    private let state: InputState
    
    @FocusState private var isFocused: Bool
    
    @Environment(\.theme) private var theme
    
    // MARK: - Init
    
    public init(
        text: Binding<String>,
        placeholder: String,
        state: InputState = .normal
    ) {
        self._text = text
        self.placeholder = placeholder
        self.state = state
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: InputTokens.spacing) {
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(theme.colors.textDisabled)
                }
                
                TextField("", text: $text)
                    .focused($isFocused)
                    .disabled(isDisabled)
                    .foregroundColor(theme.colors.textPrimary)
            }
            .padding(.horizontal, InputTokens.horizontalPadding)
            .padding(.vertical, InputTokens.verticalPadding)
            .background(backgroundColor)
            .overlay(border)
            .clipShape(RoundedRectangle(cornerRadius: InputTokens.cornerRadius))
            
            if case let .error(message) = state {
                Text(message)
                    .font(.caption)
                    .foregroundColor(theme.colors.error)
            }
        }
    }
}


// MARK: - Styling

private extension EstatiaTextField {
    
    var isDisabled: Bool {
        if case .disabled = state { return true }
        return false
    }
    
    var backgroundColor: Color {
        switch state {
        case .disabled:
            return theme.colors.surfaceVariant
        default:
            return theme.colors.surface
        }
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: InputTokens.cornerRadius)
            .stroke(borderColor, lineWidth: InputTokens.borderWidth)
    }
    
    var borderColor: Color {
        switch state {
        case .error:
            return theme.colors.error
        case .focused:
            return theme.colors.primary
        default:
            return theme.colors.surfaceVariant
        }
    }
}

