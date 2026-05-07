//
//  EstatiaOverlayContainer.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaOverlayContainer<Content: View>:
    View
{
    
    @StateObject
    private var overlayManager = OverlayManager()
    
    private let content: Content
    
    public init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }
    
    public var body: some View {
        
        ZStack {
            
            content
            
            overlayLayer
        }
        .environmentObject(overlayManager)
    }
}

private extension EstatiaOverlayContainer {
    
    var overlayLayer: some View {
        
        ZStack {
            
            ForEach(overlayManager.overlays) { entry in
                
                OverlayHost(entry: entry)
            }
        }
    }
}
