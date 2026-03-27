//
//  PlayerConfiguration.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

// MARK: - PlayerConfiguration

public struct PlayerConfiguration: Equatable, Sendable {
    
    // MARK: Playback Behavior
    
    /// Automatically start playback when media becomes ready
    public let autoPlay: Bool
    
    /// Automatically replay media when it reaches the end
    public let looping: Bool
    
    /// Start position in seconds (applied after load)
    public let startPosition: TimeInterval?
    
    
    // MARK: Buffering
    
    /// Minimum buffer required before playback starts (seconds)
    public let preferredForwardBufferDuration: TimeInterval?
    
    /// Whether playback should continue automatically after buffering
    public let automaticallyWaitsToMinimizeStalling: Bool
    
    
    // MARK: Time Observation
    
    /// Interval for progress updates (seconds)
    /// - Important: Impacts UI smoothness vs battery usage
    public let progressUpdateInterval: TimeInterval
    
    
    // MARK: Audio
    
    /// Playback rate (1.0 = normal speed)
    public let rate: Float
    
    /// Whether audio should continue in background
    public let allowsBackgroundPlayback: Bool
    
    
    // MARK: Debug / Observability
    
    /// Enable verbose logging for debugging
    public let enableLogging: Bool
    
    
    // MARK: Init
    
    public init(
        autoPlay: Bool = false,
        looping: Bool = false,
        startPosition: TimeInterval? = nil,
        preferredForwardBufferDuration: TimeInterval? = nil,
        automaticallyWaitsToMinimizeStalling: Bool = true,
        progressUpdateInterval: TimeInterval = 0.25,
        rate: Float = 1.0,
        allowsBackgroundPlayback: Bool = false,
        enableLogging: Bool = false
    ) {
        self.autoPlay = autoPlay
        self.looping = looping
        self.startPosition = startPosition
        self.preferredForwardBufferDuration = preferredForwardBufferDuration
        self.automaticallyWaitsToMinimizeStalling = automaticallyWaitsToMinimizeStalling
        self.progressUpdateInterval = progressUpdateInterval
        self.rate = rate
        self.allowsBackgroundPlayback = allowsBackgroundPlayback
        self.enableLogging = enableLogging
    }
}
