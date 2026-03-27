//
//  PlaybackProgress.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

// MARK: - PlaybackProgress

public struct PlaybackProgress: Equatable, Sendable {
    
    public let currentTime: TimeInterval
    public let duration: TimeInterval?
    public let buffered: TimeInterval?
    
    public init(
        currentTime: TimeInterval,
        duration: TimeInterval?,
        buffered: TimeInterval?
    ) {
        self.currentTime = currentTime
        self.duration = duration
        self.buffered = buffered
    }
}
