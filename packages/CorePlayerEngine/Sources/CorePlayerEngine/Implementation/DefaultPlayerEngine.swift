import Foundation

//
//  DefaultPlayerEngine.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

    
@MainActor
final class  DefaultPlayerEngine: PlayerEngine {
    var currentTime: TimeInterval
    
    var duration: TimeInterval?
    
    
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
    
    // MARK: Streams
    
    var state: AsyncStream<PlayerState> { stateEmitter.stream }
    var events: AsyncStream<PlayerEvent> { eventEmitter.stream }
    
    // MARK: API
    
    func load(_ source: MediaSource) async throws {
        try await actor.handle(PlayerIntent.load(source))
    }
    
    func play() {
        Task { @MainActor in
            do {
                try await actor.handle(PlayerIntent.play)
            } catch {
                // Consider emitting an error event if needed
                // For now, just log
                assertionFailure("PlayerEngine.play failed: \(error)")
            }
        }
    }
    
    func pause() {
        Task { @MainActor in
            do {
                try await actor.handle(PlayerIntent.pause)
            } catch {
                assertionFailure("PlayerEngine.pause failed: \(error)")
            }
        }
    }
    
    func seek(to seconds: TimeInterval) {
        Task { @MainActor in
            do {
                try await actor.handle(PlayerIntent.seek(seconds))
            } catch {
                assertionFailure("PlayerEngine.seek failed: \(error)")
            }
        }
    }
    
    func stop() {
        Task { @MainActor in
            do {
                try await actor.handle(PlayerIntent.stop)
            } catch {
                assertionFailure("PlayerEngine.stop failed: \(error)")
            }
        }
    }
    
    func release() {
        Task { @MainActor in
            do {
                try await actor.handle(PlayerIntent.release)
            } catch {
                assertionFailure("PlayerEngine.release failed: \(error)")
            }
        }
    }
    
    var currentTime: TimeInterval {
        get async { await actor.currentTime }
    }
    
    var duration: TimeInterval? {
        get async { await actor.duration }
    }
}

