//
//  EstatiaPasswordField.swift
//  CoreDesignSystem
//
//  Created by builder on 4/26/26.
//

import SwiftUI


struct EstatiaPasswordField: View {
    
    @Binding var text: String
    @State private var isSecure = true
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            
            if isSecure {
                SecureField("", text: $text)
                    .focused($isFocused)
            } else {
                EstatiaInputField(
                    text: $text,
                    placeholder: "Password",
                    kind: .text,
                    isFocused: $isFocused
                )
            }
            
            Button {
                isSecure.toggle()
            } label: {
                Image(systemName: isSecure ? "eye.slash" : "eye")
            }
        }
    }
}
