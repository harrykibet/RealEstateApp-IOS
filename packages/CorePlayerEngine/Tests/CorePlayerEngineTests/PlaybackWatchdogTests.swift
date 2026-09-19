//
//  PlaybackWatchdogTests.swift
//  CorePlayerEngine
//
//  Created by builder on 9/19/26.
//


import XCTest
@testable import CorePlayerEngine

final class PlaybackWatchdogTests: XCTestCase {

    func testStartEventuallyExpires() async {

        let watchdog = PlaybackWatchdog(
            sleep: { _ in
                // Deterministic test sleeper:
                // return immediately.
            }
        )

        let expectation = expectation(
            description: "Watchdog expired"
        )

        await watchdog.start {
            expectation.fulfill()
        }

        await fulfillment(
            of: [expectation],
            timeout: 1
        )
    }

    func testCancelPreventsExpiration() async {

        let watchdog = PlaybackWatchdog(
            sleep: { _ in
                try await Task.sleep(
                    for: .seconds(1)
                )
            }
        )

        let expectation = expectation(
            description: "Watchdog must not expire"
        )

        expectation.isInverted = true

        await watchdog.start {
            expectation.fulfill()
        }

        await watchdog.cancel()

        await fulfillment(
            of: [expectation],
            timeout: 0.1
        )
    }

    func testRestartInvalidatesPreviousGeneration() async {

        let watchdog = PlaybackWatchdog(
            sleep: { duration in
                try await Task.sleep(
                    for: duration
                )
            }
        )

        let first = expectation(
            description: "First watchdog must not expire"
        )

        first.isInverted = true

        let second = expectation(
            description: "Second watchdog expires"
        )

        await watchdog.start {
            first.fulfill()
        }

        await watchdog.start {
            second.fulfill()
        }

        await fulfillment(
            of: [second],
            timeout: 1
        )

        await fulfillment(
            of: [first],
            timeout: 0.1
        )
    }

    func testCancelIsIdempotent() async {

        let watchdog = PlaybackWatchdog()

        await watchdog.cancel()
        await watchdog.cancel()

        let running = await watchdog.isRunning

        XCTAssertFalse(running)
    }
}