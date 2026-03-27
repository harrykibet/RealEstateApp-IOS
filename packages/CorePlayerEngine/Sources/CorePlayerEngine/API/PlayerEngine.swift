//
//  PlayerEngine.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

// MARK: - PlayerEngine

@available(iOS 13.0, *)
public protocol PlayerEngine: AnyObject {
    
    // MARK: Lifecycle
    
    /// Loads a media source into the player.
    /// - Important: Must be called before play().
    func load(_ source: MediaSource) async throws
    
    /// Starts or resumes playback.
    func play()
    
    /// Pauses playback.
    func pause()
    
    /// Seeks to a specific time (in seconds).
    func seek(to seconds: TimeInterval)
    
    /// Stops playback and resets internal state.
    func stop()
    
    /// Fully releases all underlying resources.
    /// - Important: Must be called explicitly to avoid leaks.
    func release()
    
    
    // MARK: State & Events
    
    /// Continuous stream of player state updates.
    /// - Guarantees: Serialized, no concurrent emissions.
    var state: AsyncStream<PlayerState> { get }
    
    /// Discrete events emitted by the player.
    /// - Examples: buffering started, seek completed, playback ended.
    var events: AsyncStream<PlayerEvent> { get }
    
    
    // MARK: Observability
    
    /// Current snapshot of playback progress.
    /// - Note: This is a pull-based API complementing event streams.
    var currentTime: TimeInterval { get }
    
    /// Duration of the currently loaded media.
    var duration: TimeInterval? { get }
}


