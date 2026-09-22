//
//  VideoPlaybackPolicy.swift
//  CorePlayerEngine
//
//  Created by builder on 9/20/26.
//


import Foundation

public struct VideoPlaybackPolicy: Sendable, Equatable {

    // MARK: Debounce

    public let dwellDebounce: Duration
    public let flingDebounce: Duration
    public let jankAwareDebounce: Duration

    // MARK: Fling Detection

    /// Number of rapid page transitions required to classify
    /// interaction as a fling.
    public let flingTransitionThreshold: Int

    /// Maximum interval between transitions that counts
    /// toward the same fling.
    public let fastTransitionWindow: Duration
    
    public let flingVelocityThreshold: Double
    
    // MARK: Prefetch

    public let previousMinimumMatchScore: Double
    public let nextPreloadMinimumMatchScore: Double
    public let speculativeMinimumMatchScore: Double

    /// Maximum media IDs retained in the local "already warmed"
    /// bounded set.
    public let maxWarmedMedia: Int

    // MARK: Init

    public init(
        dwellDebounce: Duration = .milliseconds(100),
        flingDebounce: Duration = .milliseconds(250),
        jankAwareDebounce: Duration = .milliseconds(400),
        flingTransitionThreshold: Int = 3,
        flingVelocityThreshold: Double = 1_500,
        fastTransitionWindow: Duration = .milliseconds(300),
        previousMinimumMatchScore: Double = 0.5,
        nextPreloadMinimumMatchScore: Double = 0.8,
        speculativeMinimumMatchScore: Double = 0.4,
        maxWarmedMedia: Int = 32
    ) {
        precondition(flingTransitionThreshold > 0)
        precondition(maxWarmedMedia > 0)

        self.dwellDebounce = dwellDebounce
        self.flingDebounce = flingDebounce
        self.jankAwareDebounce = jankAwareDebounce

        self.flingTransitionThreshold =
            flingTransitionThreshold

        self.fastTransitionWindow =
            fastTransitionWindow

        self.previousMinimumMatchScore =
            previousMinimumMatchScore

        self.nextPreloadMinimumMatchScore =
            nextPreloadMinimumMatchScore

        self.speculativeMinimumMatchScore =
            speculativeMinimumMatchScore

        self.maxWarmedMedia =
            maxWarmedMedia
        
        self.flingVelocityThreshold =
            flingVelocityThreshold
    }
}
