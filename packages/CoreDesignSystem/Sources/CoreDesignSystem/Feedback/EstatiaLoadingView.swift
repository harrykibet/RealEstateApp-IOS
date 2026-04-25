//
//  LoadingView.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

public struct EstatiaLoadingView: View {
    
    private let message: String?
    
    @Environment(\.theme) private var theme
    
    public init(message: String? = nil) {
        self.message = message
    }
    
    
    public var body: some View {
        VStack(spacing: FeedbackTokens.spacing) {
            
            ProgressView()
                .tint(theme.colors.primary)
            
            if let message {
                EstatiaText(message, style: .label)
                    .foregroundColor(theme.colors.textSecondary)
            }
        }
        .padding(FeedbackTokens.verticalPadding)
    }
}

#if DEBUG

private struct LoadingViewPreviewContent: View {
    var body: some View {
        VStack(spacing: 24) {
            
            EstatiaLoadingView()
            
            EstatiaLoadingView(message: "Loading properties...")
            
            EstatiaLoadingView(message: "Fetching recommendations...")
        }
    }
}

#Preview("Loading View - Light") {
    Preview.light {
        Preview.states {
            LoadingViewPreviewContent()
        }
    }
}

#Preview("Loading View - Dark") {
    Preview.dark {
        Preview.states {
            LoadingViewPreviewContent()
        }
    }
}

#endif
