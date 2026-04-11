//
//  EmptyStateView.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

public struct EstatiaEmptyStateView: View {
    
    private let title: String
    private let message: String
    private let actionTitle: String?
    private let action: (() -> Void)?
    
    @Environment(\.theme) private var theme
    
    public init(
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: FeedbackTokens.spacing) {
            
            Image(systemName: "tray")
                .font(.system(size: FeedbackTokens.iconSize))
                .foregroundColor(theme.colors.textSecondary)
            
            Text(title)
                .font(.headline)
                .foregroundColor(theme.colors.textPrimary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(theme.colors.textSecondary)
                .multilineTextAlignment(.center)
            
            if let actionTitle, let action {
                EstatiaPrimaryButton(
                    title: actionTitle,
                    action: action
                )
            }
        }
        .padding(FeedbackTokens.verticalPadding)
    }
}
