//
//  ErroView.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

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
            
            EstatiaText(title, style: .subtitle)
                .foregroundColor(theme.colors.textPrimary)
            
            EstatiaText(message, style: .label)
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

#if DEBUG

#Preview("Error View - Light") {
    Preview.light {
        errorViewPreviewContent
    }
}

#Preview("Error View - Dark") {
    Preview.dark {
        errorViewPreviewContent
    }
}

// MARK: - Preview Content

private var errorViewPreviewContent: some View {
    VStack(spacing: 24) {
        
        // Default error (with retry)
        EstatiaErrorView(
            message: "Unable to load data. Please check your connection and try again.",
            onRetry: {}
        )
        
        // Custom error without retry
        EstatiaErrorView(
            title: "Network Error",
            message: "We couldn't connect to the server. Please try again later.",
            retryTitle: nil,
            onRetry: nil
        )
        
        // Long message (layout stress test)
        EstatiaErrorView(
            title: "Something went wrong",
            message: "An unexpected error occurred while processing your request. Please try again or contact support if the issue persists.",
            onRetry: {}
        )
    }
    .padding()
}

#endif
