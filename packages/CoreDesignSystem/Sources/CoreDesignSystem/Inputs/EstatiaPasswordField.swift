//
//  EstatiaPasswordField.swift
//  CoreDesignSystem
//
//  Created by builder on 4/26/26.
//

import SwiftUI

public struct EstatiaPasswordField: View {
    
    @Binding private var text: String
    private let state: InputState
    
    @State private var isSecure: Bool = true
    @FocusState private var isFocused: Bool
    
    @Environment(\.theme) private var theme
    
    public init(
        text: Binding<String>,
        state: InputState = .normal
    ) {
        self._text = text
        self.state = state
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: InputTokens.spacing) {
            
            EstatiaInputContainer(
                state: state,
                isFocused: isFocused
            ) {
                HStack(spacing: 8) {
                    
                    inputField
                    
                    Button(action: toggleSecure) {
                        Image(systemName: isSecure ? "eye.slash" : "eye")
                            .foregroundColor(theme.colors.textSecondary)
                    }
                }
            }
            
            if case let .error(message) = state {
                EstatiaText(message, style: .caption)
                    .foregroundColor(theme.colors.error)
            }
        }
    }
}

// MARK: - Subviews

private extension EstatiaPasswordField {
    
    @ViewBuilder
    var inputField: some View {
        if isSecure {
            SecureField("", text: $text)
                .focused($isFocused)
                .textContentType(.password)
        } else {
            EstatiaInputField(
                text: $text,
                placeholder: "Password",
                kind: .text,
                isFocused: $isFocused
            )
        }
    }
    
    func toggleSecure() {
        isSecure.toggle()
        
        // Preserve focus across SecureField ↔ TextField swap
        DispatchQueue.main.async {
            isFocused = true
        }
    }
}
#if DEBUG

private struct EstatiaPasswordFieldPreviewContainer: View {
    
    // MARK: - State
    
    @State private var emptyPassword: String = ""
    @State private var filledPassword: String = "P@ssw0rd!"
    @State private var longPassword: String = "VeryLongPassword123!@#Secure"
    @State private var invalidPassword: String = "12"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Empty
                
                section(title: "Empty") {
                    EstatiaPasswordField(
                        text: $emptyPassword
                    )
                }
                
                // MARK: - Filled
                
                section(title: "Filled") {
                    EstatiaPasswordField(
                        text: $filledPassword
                    )
                }
                
                // MARK: - Validation (Dynamic)
                
                section(title: "Validation (Weak Password)") {
                    EstatiaPasswordField(
                        text: $invalidPassword,
                        state: validationState(for: invalidPassword)
                    )
                }
                
                // MARK: - Long Password
                
                section(title: "Long Password (Layout Stress)") {
                    EstatiaPasswordField(
                        text: $longPassword
                    )
                }
                
                // MARK: - Interactive Toggle Hint
                
                section(title: "Toggle Visibility (Manual Test)") {
                    EstatiaPasswordField(
                        text: $filledPassword
                    )
                    
                    EstatiaText(
                        "Tap the eye icon to verify secure/plain switching does not reset text.",
                        style: .caption
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
        
        if trimmed.count < 6 {
            return .error("Password must be at least 6 characters")
        }
        
        return .normal
    }
}

// MARK: - Previews

#Preview("Password Field - Light") {
    Preview.light {
        EstatiaPasswordFieldPreviewContainer()
    }
}

#Preview("Password Field - Dark") {
    Preview.dark {
        EstatiaPasswordFieldPreviewContainer()
    }
}

#endif
