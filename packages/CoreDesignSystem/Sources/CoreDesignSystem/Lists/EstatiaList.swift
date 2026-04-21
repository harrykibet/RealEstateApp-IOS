//
//  EstatiaList.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaList<Content: View>: View {
    
    let content: Content
    let showsDividers: Bool
    
    public init(
        showsDividers: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.showsDividers = showsDividers
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                content
            }
        }
    }
}
