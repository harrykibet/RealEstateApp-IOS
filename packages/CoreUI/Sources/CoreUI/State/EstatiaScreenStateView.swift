//
//  EstatiaScreenStateView.swift
//  CoreUI
//
//  Created by builder on 4/9/26.
//

import SwiftUI
import CoreDesignSystem

public struct EstatiaScreenStateView<Content: View>: View {
    
    private let state: ScreenState<Void>
    private let content: () -> Content
    private let onRetry: (() -> Void)?
    
    public init(
        state: ScreenState<Void>,
        onRetry: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = state
        self.onRetry = onRetry
        self.content = content
    }
    
    public var body: some View {
        Group {
            switch state {
                
            case .loading:
                EstatiaLoadingView(message: "Loading...")
                
            case .error(let message):
                EstatiaErrorView(message: message, onRetry: onRetry)
                
            case .empty:
                EstatiaEmptyStateView(title: "No Results", message: "Try adjusting your filters")
                
            case .content:
                content()
                
            }
        }
    }
}
