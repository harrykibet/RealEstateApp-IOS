//
//  SecondaryButton.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

public struct EstatiaSecondaryButton: View {
    
    private let title: String
    private let isEnabled: Bool
    private let action: () -> Void
    
    public init(
        title: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    public var body: some View {
        AppButton(
            style: .secondary,
            isEnabled: isEnabled,
            action: action
        ) {
            Text(title).font(.headline)
        }
    }
}

#if DEBUG
import SwiftUI

#Preview("Secondary Button - Light") {
    PreviewContainer {
        VStack(spacing: 16) {
            EstatiaSecondaryButton(
                title: "Filter",
                action: {}
            )
            
            EstatiaSecondaryButton(
                title: "Disabled",
                isEnabled: false,
                action: {}
            )
        }
    }
}

#Preview("Secondary Button - Dark") {
    PreviewContainer(isDarkMode: true) {
        VStack(spacing: 16) {
            EstatiaSecondaryButton(
                title: "Filter",
                action: {}
            )
            
            EstatiaSecondaryButton(
                title: "Disabled",
                isEnabled: false,
                action: {}
            )
        }
    }
}

#endif
