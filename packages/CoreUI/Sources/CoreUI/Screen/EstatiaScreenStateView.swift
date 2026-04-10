//
//  EstatiaScreenStateView.swift
//  CoreUI
//
//  Created by builder on 4/9/26.
//

import SwiftUI
import CoreDesignSystem

public struct EstatiaScreenStateView<Content: View>: View {
    
    private let uiState: ScreenUIState
    private let content: () -> Content
    private let onRetry: (() -> Void)?
    private let onRefresh: (() async -> Void)?
    
    public init(
        uiState: ScreenUIState,
        onRetry: (() -> Void)? = nil,
        onRefresh: (() async -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = uiState
        self.onRetry = onRetry
        self.onRefresh = onRefresh
        self.content = content
    }
    
    public var body: some View {
        Group {
            switch uiState.state {
                
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
        .refreshable {
            guard let onRefresh else { return }
            await onRefresh()
        }
    }
}
