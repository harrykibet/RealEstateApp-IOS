//
//  TextField.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.

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
                
                if shouldShowPlaceholder {
                    Text(placeholder)
                        .foregroundColor(theme.colors.textDisabled)
                }
                
                TextField("", text: $text)
                    .focused($isFocused)
                    .disabled(isDisabled)
                    .foregroundColor(theme.colors.textPrimary)
                    .accessibilityLabel(placeholder)
                    .accessibilityValue(text)
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
                    .accessibilityHint(message)
            }
        }
    }
}

// MARK: - Derived State (Single Source of Truth)

private extension EstatiaTextField {
    
    var isDisabled: Bool {
        if case .disabled = state { return true }
        return false
    }
    
    var shouldShowPlaceholder: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var backgroundColor: Color {
        switch state {
        case .disabled:
            return theme.colors.surfaceVariant
        default:
            return theme.colors.surface
        }
    }
    
    var borderColor: Color {
        // Priority: error > focus > default
        
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

#if DEBUG

private struct EstatiaTextFieldPreviewContainer: View {
    
    @State private var emptyText: String = ""
    @State private var filledText: String = "Nairobi"
    @State private var errorText: String = "In"
    @State private var disabledText: String = "Disabled"
    
    var body: some View {
        VStack(spacing: 20) {
            
            EstatiaTextField(
                text: $emptyText,
                placeholder: "Enter location",
                state: .normal
            )
            
            EstatiaTextField(
                text: $filledText,
                placeholder: "Enter location",
                state: .normal
            )
            
            EstatiaTextField(
                text: $errorText,
                placeholder: "Enter location",
                state: validationState(for: errorText)
            )
            
            EstatiaTextField(
                text: $disabledText,
                placeholder: "Enter location",
                state: .disabled
            )
        }
        .padding()
    }
    
    // MARK: - Derived Validation
    
    private func validationState(for text: String) -> InputState {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return .normal
        }
        
        if trimmed.count < 3 {
            return .error("Minimum 3 characters")
        }
        
        return .normal
    }
}

#Preview("TextField - Light") {
    Preview.light {
        EstatiaTextFieldPreviewContainer()
    }
}

#Preview("TextField - Dark") {
    Preview.dark {
        EstatiaTextFieldPreviewContainer()
    }
}

#endif
