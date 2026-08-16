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
            style: .filled,
            isEnabled: isEnabled,
            isLoading: isLoading,
            action: action
        ) {
            EstatiaText(title, style: .subtitle)
        }
    }
}

#if DEBUG

#Preview("Primary Button - Light") {
    Preview.light {
        primaryButtonPreviewContent
    }
}

#Preview("Primary Button - Dark") {
    Preview.dark {
        primaryButtonPreviewContent
    }
}

// MARK: - Preview Content

private var primaryButtonPreviewContent: some View {
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
}

#endif
