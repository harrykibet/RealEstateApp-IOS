//
//  VideoPlaybackCoordinatorTests.swift
//  CorePlayerEngine
//
//  Created by builder on 9/22/26.
//


import XCTest
@testable import CorePlayerEngine

@MainActor
final class VideoPlaybackCoordinatorTests: XCTestCase {

    // MARK: - Test Doubles

    final class FakePlayback:
        VideoPlaybackTarget {

        private(set) var activeMediaId:
            String?

        private(set) var playRequests:
            [String] = []

        private(set) var preloadRequests:
            [String] = []

        private(set) var pinnedSnapshots:
            [Set<String>] = []

        private(set) var pauseCount = 0

        func play(
            mediaId: String,
            source: MediaSource
        ) async throws {

            playRequests.append(
                mediaId
            )

            activeMediaId =
                mediaId
        }

        func preload(
            mediaId: String,
            source: MediaSource
        ) async {

            preloadRequests.append(
                mediaId
            )
        }

        func updateComposedMedia(
            _ mediaIds: Set<String>
        ) async {

            pinnedSnapshots.append(
                mediaIds
            )
        }

        func observeState(
            mediaId: String
        ) async -> AsyncStream<PlayerState>? {
            nil
        }

        func isMediaActive(
            _ mediaId: String
        ) -> Bool {

            activeMediaId ==
                mediaId
        }

        func pauseCurrent() async {

            pauseCount += 1
            activeMediaId = nil
        }
    }

    final class FakeStreamingPipeline:
        StreamingPipeline {

        struct WarmCall:
            Equatable {

            let mediaId: String
            let priority: WarmPriority
        }

        private(set) var warmCalls:
            [WarmCall] = []

        func warm(
            mediaId: String,
            source: MediaSource,
            priority: WarmPriority
        ) async {

            warmCalls.append(
                WarmCall(
                    mediaId: mediaId,
                    priority: priority
                )
            )
        }
    }

    actor SleepRecorder {

        private(set) var durations:
            [Duration] = []

        func record(
            _ duration: Duration
        ) {
            durations.append(
                duration
            )
        }

        func snapshot()
            -> [Duration] {

            durations
        }
    }

    // MARK: - Helpers

    private func makeSource(
        _ id: String
    ) -> MediaSource {

        MediaSource(
            url: URL(
                string:
                    "https://example.com/\(id).mp4"
            )!
        )
    }

    private func makeItem(
        _ id: String,
        score: Double = 0.5
    ) -> FeedPlaybackItem {

        FeedPlaybackItem(
            mediaId: id,
            source: makeSource(id),
            matchScore: score
        )
    }

    private func makeCoordinator(
        playback: FakePlayback,
        streaming: FakeStreamingPipeline,
        policy: VideoPlaybackPolicy =
            VideoPlaybackPolicy(),
        sleepRecorder:
            SleepRecorder? = nil
    ) -> VideoPlaybackCoordinator {

        VideoPlaybackCoordinator(
            playback: playback,
            streamingPipeline: streaming,
            policy: policy,
            sleep: { duration in

                await sleepRecorder?
                    .record(duration)

                // Give scheduled coordinator tasks an
                // opportunity to interleave deterministically.
                await Task.yield()
            }
        )
    }

    private func waitUntil(
        timeoutIterations: Int = 100,
        condition: @escaping @MainActor () -> Bool
    ) async {

        for _ in 0..<timeoutIterations {

            if condition() {
                return
            }

            await Task.yield()
        }

        XCTFail(
            "Condition was not satisfied within the test window."
        )
    }

    // MARK: - Playback

    func testVisibleItemStartsPlayback() async {

        let playback =
            FakePlayback()

        let streaming =
            FakeStreamingPipeline()

        let coordinator =
            makeCoordinator(
                playback: playback,
                streaming: streaming
            )

        coordinator.onItemVisible(
            makeItem("current")
        )

        await waitUntil {
            playback.playRequests ==
                ["current"]
        }

        XCTAssertEqual(
            playback.activeMediaId,
            "current"
        )
    }

    // MARK: - Fling

    func testFlingSuppressesNeighborPreloading()
        async {

        let playback =
            FakePlayback()

        let streaming =
            FakeStreamingPipeline()

        let coordinator =
            makeCoordinator(
                playback: playback,
                streaming: streaming
            )

        coordinator.onItemVisible(
            makeItem("current"),
            previous: [
                makeItem("previous", score: 1.0)
            ],
            next: [
                makeItem("next", score: 1.0),
                makeItem("speculative", score: 1.0)
            ],
            context: FeedPlaybackContext(
                scrollVelocity: 2_000
            )
        )

        await waitUntil {
            playback.playRequests.count == 1
        }

        // Give the preload task a chance to run.
        await Task.yield()
        await Task.yield()

        XCTAssertTrue(
            playback.preloadRequests.isEmpty
        )

        XCTAssertTrue(
            streaming.warmCalls.isEmpty
        )
    }

    // MARK: - Neighbor Warming

    func testNeighborsUseExpectedPriorities()
        async {

        let playback =
            FakePlayback()

        let streaming =
            FakeStreamingPipeline()

        let coordinator =
            makeCoordinator(
                playback: playback,
                streaming: streaming
            )

        coordinator.onItemVisible(
            makeItem("current"),
            previous: [
                makeItem(
                    "previous",
                    score: 0.6
                )
            ],
            next: [
                makeItem(
                    "next",
                    score: 0.9
                ),
                makeItem(
                    "speculative",
                    score: 0.5
                )
            ]
        )

        await waitUntil {
            streaming.warmCalls.count == 3
        }

        XCTAssertEqual(
            playback.preloadRequests,
            ["next"]
        )

        XCTAssertEqual(
            streaming.warmCalls,
            [
                .init(
                    mediaId: "previous",
                    priority: .previous
                ),
                .init(
                    mediaId: "next",
                    priority: .next
                ),
                .init(
                    mediaId: "speculative",
                    priority: .speculative
                )
            ]
        )
    }

    // MARK: - Score Thresholds

    func testLowScoreItemsAreNotPreloadedOrWarmed()
        async {

        let playback =
            FakePlayback()

        let streaming =
            FakeStreamingPipeline()

        let coordinator =
            makeCoordinator(
                playback: playback,
                streaming: streaming
            )

        coordinator.onItemVisible(
            makeItem("current"),
            previous: [
                makeItem(
                    "previous",
                    score: 0.4
                )
            ],
            next: [
                makeItem(
                    "next",
                    score: 0.7
                ),
                makeItem(
                    "speculative",
                    score: 0.3
                )
            ]
        )

        await waitUntil {
            playback.playRequests.count == 1
        }

        await Task.yield()
        await Task.yield()

        XCTAssertTrue(
            playback.preloadRequests.isEmpty
        )

        XCTAssertEqual(
            streaming.warmCalls,
            [
                .init(
                    mediaId: "next",
                    priority: .next
                )
            ]
        )
    }

    // MARK: - Warm Deduplication

    func testSameMediaIsWarmedOnlyOnce()
        async {

        let playback =
            FakePlayback()

        let streaming =
            FakeStreamingPipeline()

        let coordinator =
            makeCoordinator(
                playback: playback,
                streaming: streaming
            )

        let next =
            makeItem(
                "next",
                score: 1.0
            )

        coordinator.onItemVisible(
            makeItem("current"),
            next: [next]
        )

        await waitUntil {
            streaming.warmCalls.count == 1
        }

        coordinator.onItemVisible(
            makeItem("current-2"),
            next: [next]
        )

        await waitUntil {
            playback.playRequests.count == 2
        }

        await Task.yield()
        await Task.yield()

        XCTAssertEqual(
            streaming.warmCalls.count,
            1
        )
    }

    // MARK: - Jank

    func testJankUsesJankAwareDebounce()
        async {

        let playback =
            FakePlayback()

        let streaming =
            FakeStreamingPipeline()

        let recorder =
            SleepRecorder()

        let coordinator =
            makeCoordinator(
                playback: playback,
                streaming: streaming,
                sleepRecorder: recorder
            )

        coordinator.onItemVisible(
            makeItem("current"),
            context: FeedPlaybackContext(
                scrollVelocity: 0,
                isJanking: true
            )
        )

        await waitUntil {
            playback.playRequests.count == 1
        }

        let durations =
            await recorder.snapshot()

        XCTAssertTrue(
            durations.contains(
                .milliseconds(400)
            )
        )
    }

    // MARK: - Pinning

    func testComposedMediaIsForwardedForPinning()
        async {

        let playback =
            FakePlayback()

        let streaming =
            FakeStreamingPipeline()

        let coordinator =
            makeCoordinator(
                playback: playback,
                streaming: streaming
            )

        let pinned: Set<String> = [
            "one",
            "two"
        ]

        await coordinator.updateComposedMedia(
            pinned
        )

        XCTAssertEqual(
            playback.pinnedSnapshots,
            [pinned]
        )
    }

    // MARK: - Pause

    func testPauseInvalidatesCurrentPlayback()
        async {

        let playback =
            FakePlayback()

        let streaming =
            FakeStreamingPipeline()

        let coordinator =
            makeCoordinator(
                playback: playback,
                streaming: streaming
            )

        coordinator.onItemVisible(
            makeItem("current")
        )

        await waitUntil {
            playback.playRequests.count == 1
        }

        await coordinator.pause()

        XCTAssertEqual(
            playback.pauseCount,
            1
        )

        XCTAssertNil(
            playback.activeMediaId
        )
    }

    // MARK: - Clear

    func testClearAllowsPreviouslyWarmedMediaToWarmAgain()
        async {

        let playback =
            FakePlayback()

        let streaming =
            FakeStreamingPipeline()

        let coordinator =
            makeCoordinator(
                playback: playback,
                streaming: streaming
            )

        let next =
            makeItem(
                "next",
                score: 1.0
            )

        coordinator.onItemVisible(
            makeItem("current"),
            next: [next]
        )

        await waitUntil {
            streaming.warmCalls.count == 1
        }

        coordinator.clear()

        coordinator.onItemVisible(
            makeItem("current-2"),
            next: [next]
        )

        await waitUntil {
            streaming.warmCalls.count == 2
        }

        XCTAssertEqual(
            streaming.warmCalls.count,
            2
        )
    }
}