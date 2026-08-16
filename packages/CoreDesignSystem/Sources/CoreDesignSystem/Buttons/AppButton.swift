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
        self.content = content()
    }

    public var body: some View {
        Button(action: handleTap) {
            ZStack {
                content
                    .opacity(isLoading ? 0 : 1)
                    .font(.system(size: 14, weight: .medium))
                    .kerning(0.1)

                if isLoading {
                    ProgressView()
                        .tint(theme.colors.primary)
                }
            }
            .frame(height: 48)
            .frame(maxWidth: style == .text ? nil : .infinity)
            .padding(.horizontal, 16)
            .background(backgroundView)
            .foregroundColor(foregroundColor)
            .overlay(borderOverlay)
            .cornerRadius(12)
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.6)
    }

    private func handleTap() {
        guard isEnabled, !isLoading else { return }
        action()
    }
}

// MARK: - Styling Helpers

private extension AppButton {
    @ViewBuilder
    var backgroundView: some View {
        switch style {
        case .filled:
            theme.colors.primary
        case .outlined, .text:
            Color.clear
        }
    }

    @ViewBuilder
    var borderOverlay: some View {
        switch style {
        case .outlined:
            RoundedRectangle(cornerRadius: 12)
                .stroke(theme.colors.primary, lineWidth: 1)
        default:
            EmptyView()
        }
    }

    var foregroundColor: Color {
        switch style {
        case .filled:
            return theme.colors.onPrimary
        case .outlined, .text:
            return theme.colors.primary
        }
    }
}
