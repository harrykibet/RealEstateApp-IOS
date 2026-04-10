//
//  AppButton.swift
//  CoreDesignSystem
//
//  Created by builder on 4/5/26.
//

import SwiftUI

@available(iOS 13.0, *)
public struct AppButton<Content: View>: View {
    
    private let style: AppButtonStyle
    private let action: () -> Void
    private let isEnabled: Bool
    private let isLoading: Bool
    private let content: Content
    
    @Environment(\.theme) private var theme
    
    public init(
        style: AppButtonStyle,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
        self.content = content()
    }
    
    public var body: some View {
        Button(action: handleTap) {
            ZStack {
                content
                    .opacity(isLoading ? 0 : 1)
                
                if isLoading {
                    ProgressView()
                        .tint(theme.colors.primary)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: style == .iconOnly ? nil : .infinity)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
    
    private func handleTap() {
        guard isEnabled, !isLoading else { return }
        action()
    }
}

// MARK: - Styling

@available(iOS 13.0, *)
private extension AppButton {
    
    var backgroundColor: Color {
        switch style {
        case .primary:
            return theme.colors.primary
        case .secondary:
            return theme.colors.surfaceVariant
        case .iconOnly:
            return .clear
        }
    }
    
    var foregroundColor: Color {
        switch style {
        case .primary:
            return theme.colors.onPrimary
        case .secondary:
            return theme.colors.textPrimary
        case .iconOnly:
            return theme.colors.textPrimary
        }
    }
    
    var horizontalPadding: CGFloat {
        style == .iconOnly ? 8 : 16
    }
    
    var verticalPadding: CGFloat {
        style == .iconOnly ? 8 : 12
    }
}
