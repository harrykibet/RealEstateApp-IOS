//
//  EstatiaList.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaList<Content: View>: View {
    
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                content
            }
        }
    }
}

