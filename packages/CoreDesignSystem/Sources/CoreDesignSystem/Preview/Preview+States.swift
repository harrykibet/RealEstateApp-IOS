//
//  Preview+States.swift
//  CoreDesignSystem
//
//  Created by builder on 4/11/26.
//

import SwiftUI

@MainActor
public extension Preview {
    
    static func states<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) -> some View {
        VStack(spacing: 16) {
            content()
        }
        .padding()
    }
}
