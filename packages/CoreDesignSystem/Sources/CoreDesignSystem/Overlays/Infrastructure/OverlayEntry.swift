//
//  OverlayEntry.swift
//  CoreDesignSystem
//
//  Created by builder on 5/7/26.
//

import SwiftUI

public struct OverlayEntry:
    Identifiable 
{
    
    public let id: OverlayID
    
    public let priority: OverlayPriority
    
    public let transition: OverlayTransition
    
    public let environment: OverlayEnvironment
    
    public let content: AnyView
    
    public init(
        id: OverlayID = OverlayID(),
        priority: OverlayPriority,
        transition: OverlayTransition = .opacity,
        environment: OverlayEnvironment = OverlayEnvironment(),
        @ViewBuilder content: () -> some View
    ) {
        self.id = id
        self.priority = priority
        self.transition = transition
        self.environment = environment
        self.content = AnyView(content())
    }
}
