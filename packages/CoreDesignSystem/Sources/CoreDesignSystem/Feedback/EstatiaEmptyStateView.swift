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
            
            EstatiaText(title, style: .subtitle)
                .foregroundColor(theme.colors.textPrimary)
            
            EstatiaText(message, style: .label)
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

#if DEBUG

#Preview("Empty State - Light") {
    Preview.light {
        emptyStatePreviewContent
    }
}

#Preview("Empty State - Dark") {
    Preview.dark {
        emptyStatePreviewContent
    }
}

// MARK: - Preview Content

private var emptyStatePreviewContent: some View {
    VStack(spacing: 24) {
        
        // No action
        EstatiaEmptyStateView(
            title: "No Results",
            message: "We couldn’t find any properties matching your search."
        )
        
        // With action
        EstatiaEmptyStateView(
            title: "No Favorites Yet",
            message: "Start exploring and save properties you love.",
            actionTitle: "Browse Properties",
            action: {}
        )
        
        // Long content (layout stress test)
        EstatiaEmptyStateView(
            title: "No Listings Available",
            message: "There are currently no listings available in this area. Try adjusting your filters or searching in a different location.",
            actionTitle: "Retry",
            action: {}
        )
    }
    .padding()
}

#endif
