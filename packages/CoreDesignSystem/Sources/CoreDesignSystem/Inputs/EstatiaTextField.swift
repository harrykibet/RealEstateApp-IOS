//
//  EstatiaTextField.swift
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
    
    public init(
        text: Binding<String>,
        placeholder: String,
        state: InputState = .normal)
    {
        self._text = text
        self.placeholder = placeholder
        self.state = state
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: InputTokens.spacing) {
            
            EstatiaInputField(
                text: $text,
                placeholder: placeholder,
                isFocused: $isFocused
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

// MARK: - Derived State (Single Source of Truth)
private extension EstatiaTextField {
    
    var isDisabled: Bool {
        if case .disabled = state { return true }
        return false
    }
    
    var backgroundColor: Color {
        switch state {
        case .disabled:
            return theme.colors.surfaceVariant
        default: return theme.colors.surface
        }
    }
    
    var borderColor: Color {
        // Priority: error > focus > default
        if case .error = state { return theme.colors.error }
        
        if isFocused { return theme.colors.primary }
        
        return theme.colors.surfaceVariant
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: InputTokens.cornerRadius)
            .stroke(borderColor, lineWidth: InputTokens.borderWidth)
    }
}

#if DEBUG

private struct EstatiaTextFieldPreviewContainer: View {
    
    // MARK: - State
    
    @State private var emptyText: String = ""
    @State private var validText: String = "Nairobi"
    @State private var invalidText: String = "In"
    @State private var longText: String = "Luxury 3 bedroom apartment with parking and security"
    @State private var disabledText: String = "Disabled"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Empty State
                
                section(title: "Empty") {
                    EstatiaTextField(
                        text: $emptyText,
                        placeholder: "Enter location",
                        state: .normal
                    )
                }
                
                // MARK: - Valid Input
                
                section(title: "Valid Input") {
                    EstatiaTextField(
                        text: $validText,
                        placeholder: "Enter location",
                        state: .normal
                    )
                }
                
                // MARK: - Validation (Derived)
                
                section(title: "Validation (Dynamic)") {
                    EstatiaTextField(
                        text: $invalidText,
                        placeholder: "Enter location",
                        state: validationState(for: invalidText)
                    )
                }
                
                // MARK: - Long Text (Layout Stress)
                
                section(title: "Long Text") {
                    EstatiaTextField(
                        text: $longText,
                        placeholder: "Enter location",
                        state: .normal
                    )
                }
                
                // MARK: - Disabled
                
                section(title: "Disabled") {
                    EstatiaTextField(
                        text: $disabledText,
                        placeholder: "Enter location",
                        state: .disabled
                    )
                }
            }
            .padding()
        }
    }
    
    // MARK: - Section Helper
    
    @ViewBuilder
    private func section(
        title: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            EstatiaText(title, style: .label)
            content()
        }
    }
    
    // MARK: - Validation
    
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
