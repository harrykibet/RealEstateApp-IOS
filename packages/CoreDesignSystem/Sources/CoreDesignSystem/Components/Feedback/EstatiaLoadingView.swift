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
                .tint(EstatiaTheme.colors.primary)
            
            if let message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(EstatiaTheme.colors.textSecondary)
            }
        }
        .padding(FeedbackTokens.verticalPadding)
    }
}
