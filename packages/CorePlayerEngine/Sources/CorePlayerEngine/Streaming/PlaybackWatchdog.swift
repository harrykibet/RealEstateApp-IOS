//
//  PlaybackWatchdog.swift
//  CorePlayerEngine
//
//  Created by builder on 9/19/26.
//


import Foundation

/// Owns timeout scheduling for a single playback lifecycle.
///
/// Invariants:
/// - At most one watchdog task is active at a time.
/// - Starting a new watchdog invalidates every previous timeout.
/// - Cancelling a watchdog invalidates the current generation.
/// - A stale timeout can never invoke the expiration callback.
/// - Timing is dependency-injected so tests do not require real delays.
public actor PlaybackWatchdog {

    // MARK: - Configuration

    public struct Configuration: Sendable, Equatable {

        public let bufferingTimeout: Duration

        public init(
            bufferingTimeout: Duration = .seconds(7)
        ) {
            precondition(
                bufferingTimeout > .zero,
                "bufferingTimeout must be greater than zero."
            )

            self.bufferingTimeout = bufferingTimeout
        }
    }

    // MARK: - State

    private let configuration: Configuration

    private let sleep: @Sendable (
        Duration
    ) async throws -> Void

    private var task: Task<Void, Never>?

    /// Every start/cancel increments the generation.
    ///
    /// A timeout captures the generation that created it. If that generation
    /// no longer matches when the timeout wakes up, the timeout is stale.
    private var generation: UInt64 = 0

    // MARK: - Initialization

    public init(
        configuration: Configuration = Configuration(),
        sleep: @escaping @Sendable (
            Duration
        ) async throws -> Void = { duration in
            try await Task.sleep(for: duration)
        }
    ) {
        self.configuration = configuration
        self.sleep = sleep
    }

    deinit {
        task?.cancel()
    }

    // MARK: - Lifecycle

    public func start(
        onExpired: @escaping @Sendable () async -> Void
    ) {
        generation &+= 1

        let currentGeneration = generation
        let timeout = configuration.bufferingTimeout
        let sleep = self.sleep

        task?.cancel()

        task = Task { [weak self] in

            do {
                try await sleep(timeout)
            } catch {
                // Cancellation is the normal path when buffering finishes
                // or the player lifecycle is reset.
                return
            }

            guard !Task.isCancelled else {
                return
            }

            guard let self else {
                return
            }

            await self.expire(
                generation: currentGeneration,
                onExpired: onExpired
            )
        }
    }

    public func cancel() {
        generation &+= 1

        task?.cancel()
        task = nil
    }

    public var isRunning: Bool {
        task != nil
    }

    // MARK: - Internal

    private func expire(
        generation expectedGeneration: UInt64,
        onExpired: @escaping @Sendable () async -> Void
    ) async {

        guard generation == expectedGeneration else {
            return
        }

        task = nil

        await onExpired()
    }
}
