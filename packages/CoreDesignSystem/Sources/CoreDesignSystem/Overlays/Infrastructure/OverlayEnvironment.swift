//
//  OverlayEnvironment.swift
//  CoreDesignSystem
//
//  Created by builder on 5/7/26.
//

import Foundation

public struct OverlayEnvironment:
    Sendable,
    Equatable
{
    
    public let allowsBackgroundInteraction: Bool
    
    public let dismissOnBackgroundTap: Bool
    
    public let blocksAccessibilityFocus: Bool
    
    public let ignoresSafeArea: Bool
    
    public init(
        allowsBackgroundInteraction: Bool = false,
        dismissOnBackgroundTap: Bool = false,
        blocksAccessibilityFocus: Bool = true,
        ignoresSafeArea: Bool = false
    ) {
        self.allowsBackgroundInteraction = allowsBackgroundInteraction
        self.dismissOnBackgroundTap = dismissOnBackgroundTap
        self.blocksAccessibilityFocus = blocksAccessibilityFocus
        self.ignoresSafeArea = ignoresSafeArea
    }
}
