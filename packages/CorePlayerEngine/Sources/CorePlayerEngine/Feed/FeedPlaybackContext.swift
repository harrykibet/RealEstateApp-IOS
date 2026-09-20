//
//  FeedPlaybackContext.swift
//  CorePlayerEngine
//
//  Created by builder on 9/20/26.
//


import Foundation

public struct FeedPlaybackContext: Sendable, Equatable {

    /// Positive values represent forward movement.
    /// Negative values represent backward movement.
    public let scrollVelocity: Double

    /// Whether the UI/rendering layer currently reports
    /// frame-pressure/jank.
    public let isJanking: Bool

    
    public init(
        scrollVelocity: Double = 0,
        isJanking: Bool = false
    ) {
        self.scrollVelocity = scrollVelocity
        self.isJanking = isJanking
    }
}
