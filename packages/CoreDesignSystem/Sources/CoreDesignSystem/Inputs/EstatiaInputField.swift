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
    
    @FocusState private var isFocused: Bool
    
    @Environment(\.theme) private var theme
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            if shouldShowPlaceholder {
                EstatiaText(placeholder)
                    .foregroundColor(theme.colors.textDisabled)
            }
            
            TextField("", text: $text)
                .focused($isFocused)
                .foregroundColor(theme.colors.textPrimary)
        }
    }
    
    private var shouldShowPlaceholder: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
