//
//  PlayerState.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

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

// MARK: - State Transition Rules

public extension PlayerState {
    
    func canTransition(to new: PlayerState) -> Bool {
        switch (self, new) {
            
        case (.idle, .loading):
            return true
            
        case (.loading, .ready),
             (.loading, .error):
            return true
            
        case (.ready, .playing),
             (.ready, .paused),
             (.ready, .error):
            return true
            
        case (.playing, .paused),
             (.playing, .buffering),
             (.playing, .ended),
             (.playing, .error):
            return true
            
        case (.paused, .playing),
             (.paused, .buffering),
             (.paused, .error):
            return true
            
        case (.buffering, .playing),
             (.buffering, .paused),
             (.buffering, .error):
            return true
            
        case (.ended, .playing),   // replay
             (.ended, .idle):
            return true
            
        case (.error, .idle):
            return true
            
        default:
            return false
        }
    }
    
    
    var isPlayable: Bool {
        switch self {
        case .ready, .paused, .ended:
            return true
        default:
            return false
        }
    }
    
    
    var isSeekable: Bool {
        switch self {
        case .ready, .playing, .paused, .buffering:
            return true
        default:
            return false
        }
    }
}
