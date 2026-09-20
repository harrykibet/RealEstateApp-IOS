//
//  PlaybackOrchestrator.swift
//  CorePlayerEngine
//
//  Created by builder on 9/18/26.
//

import Foundation

/// Coordinates playback across multiple pooled PlayerEngine instances.
///
/// Responsibilities:
/// - determines which media is currently active
/// - pauses the previous active player
/// - prevents stale play requests from taking ownership
/// - delegates player acquisition/reuse to PlayerPool
/// - delegates streaming warm-up to StreamingPipeline
/// - provides playback state observation
///
/// Non-responsibilities:
/// - player state reduction
/// - AVFoundation operations
/// - audio-session management
/// - CDN selection
/// - bitrate policy
/// - network recovery
///
/// Those belong to specialized components.
@MainActor
public final class PlaybackOrchestrator {

    // MARK: - Dependencies

    private let pool: PlayerPool
    private let streamingPipeline: StreamingPipeline

    // MARK: - State

    public private(set) var activeMediaId: String?

    /// Monotonically increasing request generation.
    ///
    /// Every play request captures its generation. If a newer request arrives
    /// while the previous request is suspended on an async operation, the
    /// previous request becomes stale and is forbidden from taking playback
    /// ownership.
    private var playGeneration: UInt64 = 0
    
    private struct ActivePlayback: Sendable {
        let mediaId: String
        let source: MediaSource
    }
    
    private var activePlayback: ActivePlayback?
    
    // MARK: - Init

    public init(
        pool: PlayerPool,
        streamingPipeline: StreamingPipeline
    ) {
        self.pool = pool
        self.streamingPipeline = streamingPipeline
    }

    // MARK: - Play

    public func play(
        mediaId: String,
        source: MediaSource
    ) async throws {

        playGeneration &+= 1

        let generation = playGeneration

        // Stop the previous logical owner first.
        if let previousMediaId = activeMediaId,
           previousMediaId != mediaId {

            if let previous = await pool.get(
                mediaId: previousMediaId
            ) {
                try? await previous.engine.pause()
            }
        }

        let managed = try await pool.getOrCreate(
            mediaId: mediaId,
            source: source
        )

        // A newer play request arrived while acquiring/loading this player.
        guard generation == playGeneration else {

            try? await managed.engine.pause()

            throw CancellationError()
        }

        try await managed.engine.play()

        // Check again because `play()` itself suspends.
        guard generation == playGeneration else {

            try? await managed.engine.pause()

            throw CancellationError()
        }
        
        activePlayback = ActivePlayback(
            mediaId: mediaId,
            source: source
        )

        activeMediaId = mediaId

        await streamingPipeline.warm(
            mediaId: mediaId,
            source: source,
            priority: .visible
        )
    }

    // MARK: - Preload

    public func preload(
        mediaId: String,
        source: MediaSource
    ) async {

        _ = await pool.prewarm(
            mediaId: mediaId,
            source: source
        )
    }

    // MARK: - Pause

    public func pauseCurrent() async {

        // Invalidate any pending play request.
        playGeneration &+= 1

        guard let activeMediaId else {
            return
        }

        guard let managed = await pool.get(
            mediaId: activeMediaId
        ) else {
            return
        }

        try? await managed.engine.pause()
    }

    // MARK: - Resume

    public func resumeCurrent() async throws {

        guard let activeMediaId else {
            return
        }

        guard let managed = await pool.get(
            mediaId: activeMediaId
        ) else {
            return
        }

        try await managed.engine.play()
    }

    // MARK: - Stop

    public func stopCurrent() async {

        playGeneration &+= 1

        guard let activeMediaId else {
            return
        }

        guard let managed = await pool.get(
            mediaId: activeMediaId
        ) else {
            self.activeMediaId = nil
            return
        }

        try? await managed.engine.stop()

        self.activeMediaId = nil
    }

    // MARK: - Release

    public func release(
        mediaId: String
    ) async {

        if activeMediaId == mediaId {
            playGeneration &+= 1
            activeMediaId = nil
        }

        await pool.release(
            mediaId: mediaId
        )
    }

    // MARK: - State

    public func observeState(
        mediaId: String
    ) async -> AsyncStream<PlayerState>? {

        guard let managed = await pool.get(
            mediaId: mediaId
        ) else {
            return nil
        }

        return managed.engine.state
    }

    public func currentState(
        mediaId: String
    ) async -> PlayerState? {

        guard let managed = await pool.get(
            mediaId: mediaId
        ) else {
            return nil
        }

        return await managed.engine.currentState
    }

    public func isCurrentlyPlaying() async -> Bool {

        guard let activeMediaId else {
            return false
        }

        return await currentState(
            mediaId: activeMediaId
        ) == .playing
    }

    public func isMediaActive(
        _ mediaId: String
    ) -> Bool {

        activeMediaId == mediaId
    }
    
    public func updateComposedMedia(
        _ mediaIds: Set<String>
    ) async {

        await pool.updatePinnedIds(
            mediaIds
        )
    }
    
    // MARK: - Shutdown

    public func shutdown() async {

        playGeneration &+= 1
        activeMediaId = nil

        await pool.releaseAll()
    }
}

@MainActor
extension PlaybackOrchestrator: PlaybackRecoveryTarget {

    public func markNetworkUnavailable() async {

        guard let activeMediaId else {
            return
        }

        guard let managed = await pool.get(
            mediaId: activeMediaId
        ) else {
            return
        }

        let state = await managed.engine.currentState

        switch state {

        case .playing,
             .buffering,
             .ready:

            await managed.engine.notifyNetworkLost()

        default:
            break
        }
    }

    public func isActiveMediaReconnecting()
        async -> Bool {

        guard let activeMediaId else {
            return false
        }

        guard let managed = await pool.get(
            mediaId: activeMediaId
        ) else {
            return false
        }

        return await managed.engine.currentState
            == .reconnecting
    }

    public func recoverActivePlayback()
        async throws {

        guard let activePlayback else {
            return
        }

        guard let managed = await pool.get(
            mediaId: activePlayback.mediaId
        ) else {
            return
        }

        let generation = playGeneration

        try await managed.engine.load(
            activePlayback.source
        )

        // A user action may have replaced the active item while
        // recovery was awaiting the network.
        guard generation == playGeneration else {
            try? await managed.engine.pause()
            throw CancellationError()
        }

        try await managed.engine.play()

        guard generation == playGeneration else {
            try? await managed.engine.pause()
            throw CancellationError()
        }
    }

    public func failActiveRecovery() async {

        guard let activeMediaId else {
            return
        }

        guard let managed = await pool.get(
            mediaId: activeMediaId
        ) else {
            return
        }

        await managed.engine.notifyRecoveryExhausted()
    }
}
