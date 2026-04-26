//
//  EstatiaInputField.swift
//  CoreDesignSystem
//
//  Created by builder on 4/26/26.
//

import SwiftUI

struct EstatiaInputField: View {
    
    @Binding var text: String
    let placeholder: String
    let kind: InputKind
    
    var isFocused: FocusState<Bool>.Binding
    
    @Environment(\.theme) private var theme
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            if shouldShowPlaceholder {
                EstatiaText(placeholder)
                    .foregroundColor(theme.colors.textDisabled)
            }
            
            inputView
                .focused(isFocused)
                .foregroundColor(theme.colors.textPrimary)
        }
    }
}

private extension EstatiaInputField {
    
    @ViewBuilder
    var inputView: some View {
        switch kind {
        case .password:
            SecureField("", text: $text)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
            
        default:
            TextField("", text: $text)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch kind {
        case .email: return .emailAddress
        case .number: return .numberPad
        case .phone: return .phonePad
        default: return .default
        }
    }
    
    var textContentType: UITextContentType? {
        switch kind {
        case .email: return .emailAddress
        case .password: return .password
        case .phone: return .telephoneNumber
        default: return nil
        }
    }
    
    private var shouldShowPlaceholder: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
