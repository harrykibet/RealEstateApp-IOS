//
//  PlayerState.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//
// MARK: - State Transition Rules
import Foundation

// MARK: - PlayerState

public enum PlayerState: Equatable, Sendable {
    
    /// Initial state. No media loaded.
    case idle
    
    /// Media is being prepared (network, decoding, etc.)
    case loading
    
    /// Ready to play, but not yet playing.
    case ready
    
    /// Actively playing.
    case playing
    
    /// Paused by user or system.
    case paused
    
    /// Playback temporarily stalled (buffer underrun).
    case buffering
    
    /// Playback reached end of media.
    case ended
    
    /// Terminal failure state.
    case error(PlayerError)
}
