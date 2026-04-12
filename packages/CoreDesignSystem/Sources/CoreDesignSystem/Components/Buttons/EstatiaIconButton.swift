//
//  IconButtoon.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

public struct EstatiaIconButton: View {
    
    private let systemImage: String
    private let isEnabled: Bool
    private let action: () -> Void
    
    public init(
        systemImage: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.isEnabled = isEnabled
        self.action = action
    }
    
    public var body: some View {
        AppButton(
            style: .iconOnly,
            isEnabled: isEnabled,
            action: action
        ) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
        }
    }
}

#if DEBUG

#Preview("Icon Button - Light") {
    Preview.light {
        iconButtonPreviewContent
    }
}

#Preview("Icon Button - Dark") {
    Preview.dark {
        iconButtonPreviewContent
    }
}

// MARK: - Preview Content

private var iconButtonPreviewContent: some View {
    HStack(spacing: 16) {
        
        EstatiaIconButton(
            systemImage: "heart",
            action: {}
        )
        
        EstatiaIconButton(
            systemImage: "magnifyingglass",
            action: {}
        )
        
        EstatiaIconButton(
            systemImage: "bell",
            isEnabled: false,
            action: {}
        )
    }
    .padding()
}

#endif
