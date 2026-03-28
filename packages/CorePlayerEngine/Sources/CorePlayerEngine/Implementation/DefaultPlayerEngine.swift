//
//  DefaultPlayerEngine.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

@available(iOS 13.0, *)
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
    
    // MARK: Streams
    
    var state: AsyncStream<PlayerState> { stateEmitter.stream }
    var events: AsyncStream<PlayerEvent> { eventEmitter.stream }
    
    // MARK: API
    
    func load(_ source: MediaSource) async throws {
        try await actor.handle(.load(source))
    }
    
    func play() {
        Task { await actor.handle(.play) }
    }
    
    func pause() {
        Task { await actor.handle(.pause) }
    }
    
    func seek(to seconds: TimeInterval) {
        Task { await actor.handle(.seek(seconds)) }
    }
    
    func stop() {
        Task { await actor.handle(.stop) }
    }
    
    func release() {
        Task { await actor.handle(.release) }
    }
    
    var currentTime: TimeInterval {
        get async { await actor.currentTime }
    }
    
    var duration: TimeInterval? {
        get async { await actor.duration }
    }
}
