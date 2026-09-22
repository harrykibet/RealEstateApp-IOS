//
//  NetworkRecoveryCoordinator.swift
//  CorePlayerEngine
//
//  Created by builder on 9/20/26.
//


import Foundation

@MainActor
public final class NetworkRecoveryCoordinator {

    // MARK: - Dependencies

    private let network:
        NetworkConnectivityProviding

    private let playback:
        PlaybackRecoveryTarget

    private let policy:
        NetworkRecoveryPolicy

    private let sleep:
        @Sendable (Duration) async throws -> Void

    private let random:
        @Sendable () -> Double

    // MARK: - Tasks

    private var observationTask:
        Task<Void, Never>?

    private var recoveryTask:
        Task<Void, Never>?

    // MARK: - Generation

    /// Invalidates previously scheduled recovery loops.
    private var recoveryGeneration: UInt64 = 0

    // MARK: - Init

    public init(
        network: NetworkConnectivityProviding,
        playback: PlaybackRecoveryTarget,
        policy: NetworkRecoveryPolicy = NetworkRecoveryPolicy(),
        sleep: @escaping @Sendable (
            Duration
        ) async throws -> Void = { duration in
            try await Task.sleep(for: duration)
        },
        random: @escaping @Sendable () -> Double = {
            Double.random(in: -1...1)
        }
    ) {
        self.network = network
        self.playback = playback
        self.policy = policy
        self.sleep = sleep
        self.random = random
    }

    // MARK: - Lifecycle

    public func start() {

        guard observationTask == nil else {
            return
        }

        network.start()

        observationTask = Task { @MainActor [weak self] in

            guard let self else {
                return
            }

            for await snapshot in network.snapshots {

                guard !Task.isCancelled else {
                    return
                }

                await handle(
                    snapshot
                )
            }
        }
    }

    public func stop() {

        observationTask?.cancel()
        observationTask = nil

        cancelRecovery()

        network.stop()
    }
    
    // MARK: - Network Events

    private func handle(
        _ snapshot: NetworkSnapshot
    ) async {

        guard snapshot.isConnected else {

            cancelRecovery()

            await playback.markNetworkUnavailable()

            return
        }

        guard await playback.isActiveMediaReconnecting() else {
            return
        }

        scheduleRecovery()
    }

    // MARK: - Recovery

    private func scheduleRecovery() {

        recoveryGeneration &+= 1

        let generation =
            recoveryGeneration

        recoveryTask?.cancel()

        recoveryTask = Task {
            @MainActor [weak self] in

            guard let self else {
                return
            }

            await self.runRecovery(
                generation: generation
            )
        }
    }

    private func runRecovery(
        generation: UInt64
    ) async {

        for attempt in 0..<policy.maximumAttempts {

            guard !Task.isCancelled else {
                return
            }

            guard generation == recoveryGeneration else {
                return
            }

            guard network.currentSnapshot.isConnected else {
                return
            }

            guard await playback.isActiveMediaReconnecting() else {
                return
            }

            if attempt > 0 {

                let delay = policy.delay(
                    forAttempt: attempt - 1,
                    randomFactor: random()
                )

                do {
                    try await sleep(delay)
                } catch {
                    return
                }

                guard network.currentSnapshot.isConnected else {
                    return
                }
            }

            do {

                try await playback.recoverActivePlayback()

                return

            } catch is CancellationError {

                return

            } catch {

                // Recovery failed. If the player is no longer
                // reconnecting, a different terminal error won.
                guard await playback.isActiveMediaReconnecting()
                else {
                    return
                }
            }
        }

        guard generation == recoveryGeneration else {
            return
        }

        await playback.failActiveRecovery()
    }

    private func cancelRecovery() {

        recoveryGeneration &+= 1

        recoveryTask?.cancel()
        recoveryTask = nil
    }
}
