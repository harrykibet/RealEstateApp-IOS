//
//  ErroView.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

@available(iOS 13.0, *)
public struct EstatiaErrorView: View {
    
    private let title: String
    private let message: String
    private let retryTitle: String?
    private let onRetry: (() -> Void)?
    
    @Environment(\.theme) private var theme
    
    public init(
        title: String = "Something went wrong",
        message: String,
        retryTitle: String? = "Retry",
        onRetry: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.retryTitle = retryTitle
        self.onRetry = onRetry
    }
    
    public var body: some View {
        VStack(spacing: FeedbackTokens.spacing) {
            
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: FeedbackTokens.iconSize))
                .foregroundColor(theme.colors.error)
            
            Text(title)
                .font(.headline)
                .foregroundColor(theme.colors.textPrimary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(theme.colors.textSecondary)
                .multilineTextAlignment(.center)
            
            if let retryTitle, let onRetry {
                EstatiaPrimaryButton(
                    title: retryTitle,
                    action: onRetry
                )
            }
        }
        .padding(FeedbackTokens.verticalPadding)
    }
}
