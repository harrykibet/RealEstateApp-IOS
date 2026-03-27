//
//  BufferState.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

// MARK: - BufferState

public struct BufferState: Equatable, Sendable {
    
    /// Whether the player is currently buffering
    public let isBuffering: Bool
    
    /// Buffered duration ahead of current playback (seconds)
    public let bufferedDuration: TimeInterval
    
    /// Total duration (if known)
    public let duration: TimeInterval?
    
    /// Buffer percentage (0.0 → 1.0), if duration is known
    public let progress: Double?
    
    public init(
        isBuffering: Bool,
        bufferedDuration: TimeInterval,
        duration: TimeInterval?
    ) {
        self.isBuffering = isBuffering
        self.bufferedDuration = bufferedDuration
        self.duration = duration
        
        if let duration, duration > 0 {
            self.progress = min(bufferedDuration / duration, 1.0)
        } else {
            self.progress = nil
        }
    }
}
