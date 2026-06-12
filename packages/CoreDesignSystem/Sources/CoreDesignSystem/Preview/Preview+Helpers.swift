//
//  Preview+Helpers.swift
//  CoreDesignSystem
//
//  Created by builder on 4/11/26.
//

import SwiftUI

@MainActor
public enum Preview {
    
    public static func light<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) -> some View {
        PreviewContainer(colorScheme: .light) {
            content()
        }
    }
    
    public static func dark<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) -> some View {
        PreviewContainer(colorScheme: .dark) {
            content()
        }
    }
    
    public static func both<Content: View>(
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
