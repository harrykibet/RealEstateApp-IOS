//
//  Preview+Helpers.swift
//  CoreDesignSystem
//
//  Created by builder on 4/11/26.
//

import SwiftUI

public enum Preview {
    
    static func light<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) -> some View {
        PreviewContainer(colorScheme: .light) {
            content()
        }
    }
    
    static func dark<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) -> some View {
        PreviewContainer(colorScheme: .dark) {
            content()
        }
    }
    
    static func both<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) -> some View {
        Group {
            
            PreviewContainer(colorScheme: .dark) {
                content()
            }
            
            PreviewContainer(colorScheme: .light) {
                content()
            }
        }
    }
}
