//
//  PlaybackStateReducerTests.swift
//  CorePlayerEngine
//
//  Created by builder on 9/19/26.
//


import XCTest
@testable import CorePlayerEngine

final class PlaybackStateReducerTests: XCTestCase {

    func testInitialStateIsIdle() {

        let reducer = PlaybackStateReducer()

        XCTAssertEqual(
            reducer.state,
            .idle
        )
    }

    func testLoadTransitionsToLoading() {

        var reducer = PlaybackStateReducer()

        reducer.reduce(.loadStarted)

        XCTAssertEqual(
            reducer.state,
            .loading
        )
    }

    func testReadyAfterLoad() {

        var reducer = PlaybackStateReducer()

        reducer.reduce(.loadStarted)
        reducer.reduce(.ready)

        XCTAssertEqual(
            reducer.state,
            .ready
        )
    }

    func testPlayTransitionsReadyToPlaying() {

        var reducer = PlaybackStateReducer()

        reducer.reduce(.loadStarted)
        reducer.reduce(.ready)
        reducer.reduce(.play)

        XCTAssertEqual(
            reducer.state,
            .playing
        )

        XCTAssertTrue(
            reducer.shouldResumeAfterInterruption
        )
    }

    func testPauseClearsResumeIntent() {

        var reducer = PlaybackStateReducer()

        reducer.reduce(.loadStarted)
        reducer.reduce(.ready)
        reducer.reduce(.play)
        reducer.reduce(.pause)

        XCTAssertEqual(
            reducer.state,
            .paused
        )

        XCTAssertFalse(
            reducer.shouldResumeAfterInterruption
        )
    }

    func testBufferingFromPlayingReturnsToPlaying() {

        var reducer = PlaybackStateReducer()

        reducer.reduce(.loadStarted)
        reducer.reduce(.ready)
        reducer.reduce(.play)
        reducer.reduce(.bufferingStarted)
        reducer.reduce(.bufferingEnded)

        XCTAssertEqual(
            reducer.state,
            .playing
        )
    }

    func testBufferingFromPausedReturnsToReady() {

        var reducer = PlaybackStateReducer()

        reducer.reduce(.loadStarted)
        reducer.reduce(.ready)
        reducer.reduce(.play)
        reducer.reduce(.pause)
        reducer.reduce(.bufferingStarted)
        reducer.reduce(.bufferingEnded)

        XCTAssertEqual(
            reducer.state,
            .ready
        )
    }

    func testNetworkLossFromPlayingEntersReconnecting() {

        var reducer = PlaybackStateReducer()

        reducer.reduce(.loadStarted)
        reducer.reduce(.ready)
        reducer.reduce(.play)
        reducer.reduce(.networkLost)

        XCTAssertEqual(
            reducer.state,
            .reconnecting
        )

        XCTAssertTrue(
            reducer.shouldResumeAfterInterruption
        )
    }

    func testNetworkRecoveryFromPlayingResumesThroughBuffering() {

        var reducer = PlaybackStateReducer()

        reducer.reduce(.loadStarted)
        reducer.reduce(.ready)
        reducer.reduce(.play)
        reducer.reduce(.networkLost)
        reducer.reduce(.networkRestored)

        XCTAssertEqual(
            reducer.state,
            .buffering
        )
    }

    func testNetworkLossWhilePausedDoesNotAutoResume() {

        var reducer = PlaybackStateReducer()

        reducer.reduce(.loadStarted)
        reducer.reduce(.ready)
        reducer.reduce(.play)
        reducer.reduce(.pause)
        reducer.reduce(.networkLost)
        reducer.reduce(.networkRestored)

        XCTAssertEqual(
            reducer.state,
            .ready
        )

        XCTAssertFalse(
            reducer.shouldResumeAfterInterruption
        )
    }

    func testWatchdogTurnsBufferingIntoPlaybackStalled() {

        var reducer = PlaybackStateReducer()

        reducer.reduce(.loadStarted)
        reducer.reduce(.ready)
        reducer.reduce(.play)
        reducer.reduce(.bufferingStarted)
        reducer.reduce(.watchdogExpired)

        XCTAssertEqual(
            reducer.state,
            .error(.playbackStalled)
        )
    }

    func testResetReturnsToIdle() {

        var reducer = PlaybackStateReducer()

        reducer.reduce(.loadStarted)
        reducer.reduce(.ready)
        reducer.reduce(.play)

        reducer.reduce(.reset)

        XCTAssertEqual(
            reducer.state,
            .idle
        )
    }
}