//
//  MetricsCollector.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

/// Collects playback metrics for analytics and debugging.
///
/// This is intentionally lightweight and non-opinionated.
/// You can later plug this into:
/// - Firebase Analytics
/// - Custom backend
/// - Logging systems
///
/// Example tracked metrics:
/// - playback start time
/// - buffering duration
/// - error frequency
public final class MetricsCollector {
    
    // MARK: Playback Session
    
    private var playbackStartTime: Date?
    private var totalBufferingTime: TimeInterval = 0
    
    private var bufferingStartTime: Date?
    
    
    public init() {}
    
    
    // MARK: Playback
    
    public func onPlaybackStarted() {
        playbackStartTime = Date()
    }
    
    public func onPlaybackEnded() {
        guard let start = playbackStartTime else { return }
        
        let duration = Date().timeIntervalSince(start)
        
        // Hook for analytics
        log("Playback duration: \(duration)s")
    }
    
    
    // MARK: Buffering
    
    public func onBufferingStarted() {
        bufferingStartTime = Date()
    }
    
    public func onBufferingEnded() {
        guard let start = bufferingStartTime else { return }
        
        let duration = Date().timeIntervalSince(start)
        totalBufferingTime += duration
        
        bufferingStartTime = nil
        
        log("Buffering duration: \(duration)s")
    }
    
    
    // MARK: Errors
    
    public func onError(_ error: PlayerError) {
        log("Error occurred: \(error)")
    }
    
    
    // MARK: Logging Hook
    
    private func log(_ message: String) {
        // Replace with PlayerLogger or analytics integration
        print("[Metrics] \(message)")
    }
}
