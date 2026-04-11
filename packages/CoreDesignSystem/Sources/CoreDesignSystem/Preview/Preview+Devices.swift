//
//  Preview+Devices.swift
//  CoreDesignSystem
//
//  Created by builder on 4/11/26.
//

import SwiftUI

@MainActor
public extension Preview {
    
    static func device<Content: View>(
        _ device: PreviewDevice,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .previewDevice(device)
    }
    
    static func padded<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding()
    }
}
