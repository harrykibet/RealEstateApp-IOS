//
//  NetworkRecoveryCoordinatorTests.swift
//  CorePlayerEngine
//
//  Created by builder on 9/20/26.
//


import XCTest
@testable import CorePlayerEngine

@MainActor
final class NetworkRecoveryCoordinatorTests: XCTestCase {
    
    actor SleepRecorder {

        private(set) var values: [Duration] = []

        func record(
            _ duration: Duration
        ) {
            values.append(duration)
        }

        func snapshot() -> [Duration] {
            values
        }
    }
    
    @MainActor
    final class FakeNetwork:
        NetworkConnectivityProviding {

        let snapshots:
            AsyncStream<NetworkSnapshot>

        private let continuation:
            AsyncStream<NetworkSnapshot>.Continuation

        private(set) var currentSnapshot =
            NetworkSnapshot(
                status: .unknown
            )

        init() {

            let stream =
                AsyncStream<NetworkSnapshot>.makeStream()

            snapshots = stream.stream
            continuation = stream.continuation
        }

        func start() {}

        func stop() {
            continuation.finish()
        }

        func emit(
            _ snapshot: NetworkSnapshot
        ) {
            currentSnapshot = snapshot
            continuation.yield(snapshot)
        }
    }

    @MainActor
    final class FakePlayback:
        PlaybackRecoveryTarget {

        var activeMediaId: String? = "video-1"

        var reconnecting = false

        var recoveryAttempts = 0

        var successfulRecovery =
            false

        var recoveryFailuresBeforeSuccess =
            0

        var recoveryExhausted = false

        func markNetworkUnavailable() async {
            reconnecting = true
        }

        func isActiveMediaReconnecting()
            async -> Bool {
            reconnecting
        }

        func recoverActivePlayback()
            async throws {

            recoveryAttempts += 1

            if recoveryAttempts <=
                recoveryFailuresBeforeSuccess {

                throw PlayerError.network(
                    .timeout
                )
            }

            reconnecting = false
            successfulRecovery = true
        }

        func failActiveRecovery() async {
            recoveryExhausted = true
            reconnecting = false
        }
    }

    func testNetworkLossMarksActivePlaybackReconnecting()
        async {

        let network =
            FakeNetwork()

        let playback =
            FakePlayback()

        let recorder = SleepRecorder()

        let coordinator =
            NetworkRecoveryCoordinator(
                network: network,
                playback: playback,
                policy: policy,
                sleep: { duration in
                    await recorder.record(duration)
                },
                random: { 0 }
            )
            
        coordinator.start()

        network.emit(
            NetworkSnapshot(
                status: .unsatisfied
            )
        )

        await Task.yield()

        XCTAssertTrue(
            playback.reconnecting
        )

        coordinator.stop()
    }

    func testConnectivityRestorationRecoversPlayback()
        async {

        let network =
            FakeNetwork()

        let playback =
            FakePlayback()

        let recorder = SleepRecorder()

        let coordinator =
            NetworkRecoveryCoordinator(
                network: network,
                playback: playback,
                policy: policy,
                sleep: { duration in
                    await recorder.record(duration)
                },
                random: { 0 }
            )
            
        coordinator.start()

        network.emit(
            NetworkSnapshot(
                status: .unsatisfied
            )
        )

        await Task.yield()

        network.emit(
            NetworkSnapshot(
                status: .satisfied
            )
        )

        for _ in 0..<10 {
            await Task.yield()

            if playback.successfulRecovery {
                break
            }
        }

        XCTAssertTrue(
            playback.successfulRecovery
        )

        XCTAssertEqual(
            playback.recoveryAttempts,
            1
        )

        coordinator.stop()
    }

    func testRecoveryUsesRetryBackoff()
        async {

        let network =
            FakeNetwork()

        let playback =
            FakePlayback()

        playback.recoveryFailuresBeforeSuccess = 2

        let recorder = SleepRecorder()

        let coordinator =
            NetworkRecoveryCoordinator(
                network: network,
                playback: playback,
                policy: policy,
                sleep: { duration in
                    await recorder.record(duration)
                },
                random: { 0 }
            )
        
        let sleeps = await recorder.snapshot()
            
        coordinator.start()

        network.emit(
            NetworkSnapshot(
                status: .unsatisfied
            )
        )

        await Task.yield()

        network.emit(
            NetworkSnapshot(
                status: .satisfied
            )
        )

        for _ in 0..<20 {
            await Task.yield()

            if playback.successfulRecovery {
                break
            }
        }

        XCTAssertEqual(
            playback.recoveryAttempts,
            3
        )

        XCTAssertEqual(
            sleeps,
            [
                .seconds(0.5),
                .seconds(1.0)
            ]
        )

        coordinator.stop()
    }

    func testRecoveryExhaustionBecomesTerminal()
        async {

        let network =
            FakeNetwork()

        let playback =
            FakePlayback()

        playback.recoveryFailuresBeforeSuccess = 100

        let recorder = SleepRecorder()

        let coordinator =
            NetworkRecoveryCoordinator(
                network: network,
                playback: playback,
                policy: policy,
                sleep: { duration in
                    await recorder.record(duration)
                },
                random: { 0 }
            )
            
        coordinator.start()

        network.emit(
            NetworkSnapshot(
                status: .unsatisfied
            )
        )

        await Task.yield()

        network.emit(
            NetworkSnapshot(
                status: .satisfied
            )
        )

        for _ in 0..<20 {
            await Task.yield()

            if playback.recoveryExhausted {
                break
            }
        }

        XCTAssertTrue(
            playback.recoveryExhausted
        )

        coordinator.stop()
    }
}
