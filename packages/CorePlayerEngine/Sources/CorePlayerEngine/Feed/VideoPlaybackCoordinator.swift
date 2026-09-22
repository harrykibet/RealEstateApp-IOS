//
//  VideoPlaybackCoordinator.swift
//  CorePlayerEngine
//
//  Created by builder on 9/20/26.
//


import Foundation

/// Coordinates feed visibility with the generic playback engine.
///
/// Responsibilities:
/// - debounce autoplay
/// - detect rapid feed flinging
/// - select a visible media item for playback
/// - prewarm previous/next/speculative neighbors
/// - bound repeated warming
/// - pin currently composed media
/// - cancel stale visibility work
///
/// This component is intentionally independent of SwiftUI.
@MainActor
public final class VideoPlaybackCoordinator {

    // MARK: - Dependencies

    private let playback:
        PlaybackOrchestrator

    private let streamingPipeline:
        StreamingPipeline

    private let policy:
        VideoPlaybackPolicy

    private let sleep:
        @Sendable (Duration) async throws -> Void

    private let now:
        @Sendable () -> ContinuousClock.Instant

    // MARK: - Tasks

    private var playTask:
        Task<Void, Never>?

    private var preloadTask:
        Task<Void, Never>?

    // MARK: - Fling State

    private var lastVisibilityChange:
        ContinuousClock.Instant?

    private var consecutiveFastTransitions = 0

    // MARK: - Warming State

    private var warmedMedia:
        [String: UInt64] = [:]

    private var warmSequence: UInt64 = 0

    // MARK: - Request Generation

    /// Prevents an obsolete visibility event from taking control
    /// after the user has already moved to a newer item.
    private var visibilityGeneration: UInt64 = 0

    // MARK: - Init

    public init(
        playback: PlaybackOrchestrator,
        pool: PlayerPool,
        streamingPipeline: StreamingPipeline,
        policy: VideoPlaybackPolicy = VideoPlaybackPolicy(),
        sleep: @escaping @Sendable (
            Duration
        ) async throws -> Void = { duration in
            try await Task.sleep(for: duration)
        },
        now: @escaping @Sendable () -> ContinuousClock.Instant = {
            ContinuousClock.now
        }
    ) {
        self.playback = playback
        self.streamingPipeline = streamingPipeline
        self.policy = policy
        self.sleep = sleep
        self.now = now
    }
    
    private func isFlinging(
        context: FeedPlaybackContext
    ) -> Bool {

        abs(context.scrollVelocity) >= policy.flingVelocityThreshold
        ||
        consecutiveFastTransitions >= policy.flingTransitionThreshold
    }
    
    // MARK: - Visibility

    public func onItemVisible(
        _ item: FeedPlaybackItem,
        previous: [FeedPlaybackItem] = [],
        next: [FeedPlaybackItem] = [],
        context: FeedPlaybackContext = FeedPlaybackContext()
    ) {

        visibilityGeneration &+= 1

        let generation =
            visibilityGeneration

        cancelPendingWork()

        updateFlingState()

        let flinging =
            isFlinging(
                context: context
            )

        let debounce =
            calculateDebounce(
                isFlinging: flinging,
                context: context
            )
        
        playTask = Task {
            @MainActor [weak self] in

            guard let self else {
                return
            }

            do {
                try await self.sleep(
                    debounce
                )
            } catch {
                return
            }

            guard generation ==
                    self.visibilityGeneration
            else {
                return
            }

            guard !Task.isCancelled else {
                return
            }

            do {
                try await self.playVisible(
                    item,
                    generation: generation
                )
            } catch is CancellationError {
                return
            } catch {
                // Player/transport errors are surfaced by PlayerEngine
                // state and telemetry. Feed coordination should not crash
                // the host UI because one media item failed.
            }
        }

        // During a fling, speculative preloading adds pressure exactly
        // when the user is generating the most churn.
        guard !isFlinging else {
            return
        }

        preloadTask = Task {
            @MainActor [weak self] in

            guard let self else {
                return
            }

            do {
                try await self.sleep(
                    debounce
                )
            } catch {
                return
            }

            guard generation ==
                    self.visibilityGeneration
            else {
                return
            }

            await self.preloadNeighbors(
                previous: previous,
                next: next
            )
        }
    }

    // MARK: - Playback

    private func playVisible(
        _ item: FeedPlaybackItem,
        generation: UInt64
    ) async throws {

        guard generation ==
                visibilityGeneration
        else {
            throw CancellationError()
        }

        try await playback.play(
            mediaId: item.mediaId,
            source: item.source
        )

        guard generation ==
                visibilityGeneration
        else {
            throw CancellationError()
        }
    }

    // MARK: - Neighbor Preloading

    private func preloadNeighbors(
        previous: [FeedPlaybackItem],
        next: [FeedPlaybackItem]
    ) async {

        // N-1
        if let previous = previous.first,
           previous.matchScore >=
            policy.previousMinimumMatchScore {

            await warm(
                previous,
                priority: .previous
            )
        }

        // N+1
        if let next = next.first {

            if next.matchScore >=
                policy.nextPreloadMinimumMatchScore {

                await playback.preload(
                    mediaId: next.mediaId,
                    source: next.source
                )
            }

            await warm(
                next,
                priority: .next
            )
        }

        // N+2
        if let speculative = next.dropFirst().first,
           speculative.matchScore >=
            policy.speculativeMinimumMatchScore {

            await warm(
                speculative,
                priority: .speculative
            )
        }
    }

    // MARK: - Warming

    private func warm(
        _ item: FeedPlaybackItem,
        priority: WarmPriority
    ) async {

        guard markWarmed(
            item.mediaId
        ) else {
            return
        }

        await streamingPipeline.warm(
            mediaId: item.mediaId,
            source: item.source,
            priority: priority
        )
    }

    @discardableResult
    private func markWarmed(
        _ mediaId: String
    ) -> Bool {

        if warmedMedia[mediaId] != nil {
            return false
        }

        warmSequence &+= 1

        warmedMedia[mediaId] =
            warmSequence

        trimWarmedMediaIfNeeded()

        return true
    }

    private func trimWarmedMediaIfNeeded() {

        guard warmedMedia.count >
                policy.maxWarmedMedia
        else {
            return
        }

        let excess =
            warmedMedia.count -
            policy.maxWarmedMedia

        let oldest =
            warmedMedia
                .sorted {
                    $0.value < $1.value
                }
                .prefix(excess)
                .map(\.key)

        for mediaId in oldest {
            warmedMedia.removeValue(
                forKey: mediaId
            )
        }
    }

    // MARK: - Pinning

    public func updateComposedMedia(
        _ mediaIds: Set<String>
    ) async {

        await playback.updateComposedMedia(
            mediaIds
        )
    }

    // MARK: - State

    public func observeState(
        mediaId: String
    ) async -> AsyncStream<PlayerState>? {

        await playback.observeState(
            mediaId: mediaId
        )
    }

    public func isMediaActive(
        _ mediaId: String
    ) -> Bool {

        playback.isMediaActive(
            mediaId
        )
    }

    // MARK: - Retry

    public func retry(
        _ item: FeedPlaybackItem
    ) async throws {

        visibilityGeneration &+= 1

        playTask?.cancel()

        try await playback.play(
            mediaId: item.mediaId,
            source: item.source
        )
    }

    // MARK: - Pause

    public func pause() async {

        visibilityGeneration &+= 1

        cancelPendingWork()

        await playback.pauseCurrent()
    }

    // MARK: - Reset

    public func clear() {

        visibilityGeneration &+= 1

        cancelPendingWork()

        warmedMedia.removeAll(
            keepingCapacity: true
        )

        lastVisibilityChange = nil
        consecutiveFastTransitions = 0
    }

    // MARK: - Internal

    private func cancelPendingWork() {

        playTask?.cancel()
        playTask = nil

        preloadTask?.cancel()
        preloadTask = nil
    }

    private func calculateDebounce(
        isFlinging: Bool,
        context: FeedPlaybackContext
    ) -> Duration {

        if context.isJanking {
            return policy.jankAwareDebounce
        }

        if isFlinging {
            return policy.flingDebounce
        }

        return policy.dwellDebounce
    }
    
    private func updateFlingState() {

        let current =
            now()

        guard let last =
                lastVisibilityChange
        else {

            lastVisibilityChange =
                current

            consecutiveFastTransitions =
                0

            return
        }

        let elapsed =
            last.duration(
                to: current
            )

        if elapsed <=
            policy.fastTransitionWindow {

            consecutiveFastTransitions += 1

        } else {

            consecutiveFastTransitions = 0
        }

        lastVisibilityChange =
            current
    }
}
