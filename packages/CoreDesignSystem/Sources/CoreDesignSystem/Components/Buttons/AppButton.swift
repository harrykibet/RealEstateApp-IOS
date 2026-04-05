//
//  AppButton.swift
//  CoreDesignSystem
//
//  Created by builder on 4/5/26.
//

import SwiftUI

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
        self.content = content
    }
    
    public var body: some View {
        Button(action: handleTab) {
            ZStack {
                content.opacity(isLoading ? 0 : 1)
                if(isLoading) {
                    ProgressView()
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: style == .iconOnly ? nil : .infinity)
            .background(backgroundColor)
            .foreground(foregroundColor)
            .clipshape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
    
    private func handleTab() {
        guard isEnabled, !isLoading else { return }
        action()
    }
}

// MARK: - Styling
private extension AppButton {
    var backgroundColor: Color {
        switch style {
        case .primary:
            return EstatiaTheme.colors.primary
        case .secondary:
            return EstatiaTheme.colors.surfaceMuted
        case .iconOnly:
            return Color.clear
        }
    }
    
    var foregroundColor: Color {
        switch style {
        case .primary:
            return EstatiaTheme.colors.primaryForeground
        case .secondary:
            return EstatiaTheme.colors.textPrimary
        case .iconOnly:
            return EstatiaTheme.colors.textPrimary
        }
    }
    
    var horizontalPadding: CGFloat {
        switch style {
        case .iconOnly:
            return 8
        default:
            return 16
        }
    }
    
    var verticalPadding: CGFloat {
        switch style {
        case .iconOnly:
            return 8
        default:
            return 12
        }
    }
}
