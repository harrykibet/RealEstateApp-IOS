//
//  DefaultPlayerEngine.swift
//  CorePlayerEngine
//
//  Created by builder on 9/18/26.
//

import Foundation

@MainActor
final class DefaultPlayerEngine: PlayerEngine {

    private let actor: PlayerActor

    private let stateEmitter = PlayerEventEmitter<PlayerState>()
    private let eventEmitter = PlayerEventEmitter<PlayerEvent>()

    init(
        config: PlayerConfiguration,
        player: AVPlayerWrapper
    ) {
        self.actor = PlayerActor(
            config: config,
            player: player,
            stateEmitter: stateEmitter,
            eventEmitter: eventEmitter
        )
    }

    // MARK: - Streams

    var state: AsyncStream<PlayerState> {
        stateEmitter.stream
    }
    
    var currentState: PlayerState {
        get async {
            await actor.currentState
        }
    }
    
    var events: AsyncStream<PlayerEvent> {
        eventEmitter.stream
    }

    // MARK: - Lifecycle

    func load(_ source: MediaSource) async throws {
        try await actor.handle(.load(source))
    }

    func play() async throws {
        try await actor.handle(.play)
    }

    func pause() async throws {
        try await actor.handle(.pause)
    }

    func seek(to seconds: TimeInterval) async throws {
        try await actor.handle(.seek(seconds))
    }

    func stop() async throws {
        try await actor.handle(.stop)
    }

    func release() async throws {
        try await actor.handle(.release)
    }

    // MARK: - Observability

    var currentTime: TimeInterval {
        get async {
            await actor.currentTime
        }
    }

    var duration: TimeInterval? {
        get async {
            await actor.duration
        }
    }
}
