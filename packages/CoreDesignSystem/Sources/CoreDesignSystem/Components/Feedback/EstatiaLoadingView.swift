//
//  LoadingView.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

@available(iOS 13.0, *)
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
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(theme.colors.textSecondary)
            }
        }
        .padding(FeedbackTokens.verticalPadding)
    }
}
