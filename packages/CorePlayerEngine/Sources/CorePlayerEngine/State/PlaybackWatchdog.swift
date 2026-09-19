//
//  PlaybackWatchdog.swift
//  CorePlayerEngine
//
//  Created by builder on 9/19/26.
//


import Foundation

@MainActor
public final class PlaybackWatchdog {

    public struct Configuration: Sendable, Equatable {
        public let bufferingTimeout: Duration

        public init(
            bufferingTimeout: Duration = .seconds(7)
        ) {
            precondition(
                bufferingTimeout > .zero,
                "bufferingTimeout must be greater than zero"
            )

            self.bufferingTimeout = bufferingTimeout
        }
    }

    private let configuration: Configuration
    private var task: Task<Void, Never>?

    public init(
        configuration: Configuration = Configuration()
    ) {
        self.configuration = configuration
    }

    public var isRunning: Bool {
        task != nil
    }

    public func start(
        onExpired: @escaping @MainActor @Sendable () -> Void
    ) {
        cancel()

        let timeout = configuration.bufferingTimeout

        task = Task { @MainActor [weak self] in
            do {
                try await Task.sleep(for: timeout)

                guard !Task.isCancelled else {
                    return
                }

                onExpired()
                self?.task = nil

            } catch {
                self?.task = nil
            }
        }
    }

    public func cancel() {
        task?.cancel()
        task = nil
    }

    deinit {
        task?.cancel()
    }
}