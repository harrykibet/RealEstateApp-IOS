//
//  PrimaryButton.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

public struct EstatiaPrimaryButton: View {
    
    private let title: String
    private let isEnabled: Bool
    private let isLoading: Bool
    private let action: () -> Void
    
    public init(
        title: String,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }
    
    public var body: some View {
        AppButton(
            style: .primary,
            isEnabled: isEnabled,
            isLoading: isLoading,
            action: action
        ) {
            Text(tittle).font(.headline)
        }
    }
}

#if DEBUG

#Preview("Primary Button - Light") {
    ThemeProvider{
        VStack(spacing: 16) {
            
            EstatiaPrimaryButton(
                title: "Search Properties",
                action: {}
            )
            
            EstatiaPrimaryButton(
                title: "Loading...",
                isLoading: true,
                action: {}
            )
            
            EstatiaPrimaryButton(
                title: "Disabled",
                isDisabled: true,
                action: {}
            )
        }
        .padding()
        .background(Color.white)
    }
}

#Preview("Primary Button - Dark") {
    ThemeProvider {
        VStack(spacing: 16) {
            
            EstatiaPrimaryButton(
                title: "Search Properties",
                action: {}
            )
            
            EstatiaPrimaryButton(
                title: "Loading...",
                isLoading: true,
                action: {}
            )
            
            EstatiaPrimaryButton(
                title: "Disabled",
                isEnabled: false,
                action: {}
            )
        }
        .padding()
        .background(Color.black)
    }
    .environment(\.colorScheme, .dark)
}
#endif
