//
//  PlayerActor.swift
//  CorePlayerEngine
//
//  Responsibility:
//  - Central state machine for playback
//  - Owns authoritative PlayerState
//  - Consumes PlayerEvent signals from AV layer
//  - Emits PlayerEvent + PlayerState externally
//
//  Design:
//  - Actor = single-threaded state authority
//  - Intent-driven API (PlayerIntent)
//  - Event-driven internal updates
//  - No direct AVFoundation coupling
//

import Foundation

    
actor PlayerActor {

    // MARK: - Dependencies

    private let config: PlayerConfiguration
    private let player: AVPlayerWrapper

    private let stateEmitter: PlayerEventEmitter<PlayerState>
    private let eventEmitter: PlayerEventEmitter<PlayerEvent>

    // MARK: - State

    private var state: PlayerState = .idle
    private var currentSource: MediaSource?

    private var currentTimeInternal: TimeInterval = 0
    private var durationInternal: TimeInterval?

    /// Tracks last stable playback intent to resolve buffering transitions correctly
    private var lastUserIntent: PlayerIntent?

    // MARK: - Init

    init(
        config: PlayerConfiguration,
        player: AVPlayerWrapper,
        stateEmitter: PlayerEventEmitter<PlayerState>,
        eventEmitter: PlayerEventEmitter<PlayerEvent>
    ) {
        self.config = config
        self.player = player
        self.stateEmitter = stateEmitter
        self.eventEmitter = eventEmitter

        // Bind AV layer → PlayerEvent → Actor without calling an actor-isolated method from init
        // Map AVPlayerWrapper callbacks to PlayerEvent and forward to the actor
        player.onReady = { [weak self] in
            guard let self else { return }
            Task { await self.consume(.ready) }
        }

        player.onBuffering = { [weak self] buffering in
            guard let self else { return }
            Task { await self.consume(buffering ? .bufferingStarted : .bufferingEnded) }
        }

        player.onCompletion = { [weak self] in
            guard let self else { return }
            Task { await self.consume(.playbackCompleted) }
        }

        player.onError = { [weak self] error in
            guard let self else { return }
            Task { await self.consume(.failed(error)) }
        }

        player.onProgress = { [weak self] progress in
            guard let self else { return }
            Task { await self.consume(.progress(progress)) }
        }
    }

    deinit {
        // Ensure underlying resources are released
        player.release()
    }

    // Expose read-only snapshots for engine consumers
    nonisolated var currentTime: TimeInterval { currentTimeInternal }
    nonisolated var duration: TimeInterval? { durationInternal }
}

    
private extension PlayerActor {

    /// Consumes low-level PlayerEvent and maps to state transitions.
    func consume(_ event: PlayerEvent) async {

        switch event {

        case .ready:
            try? transition(to: .ready)
            emitEvent(.ready)

            if config.autoPlay {
                await handle(.play)
            }

        case .bufferingStarted:
            try? transition(to: .buffering)
            emitEvent(.bufferingStarted)

        case .bufferingEnded:
            // Resume only if last intent was play
            if lastUserIntent == .play {
                try? transition(to: .playing)
            }
            emitEvent(.bufferingEnded)

        case .playbackCompleted:
            try? transition(to: .ended)
            emitEvent(.playbackCompleted)

            if config.looping {
                await handle(.play)
            }

        case .progress(let progress):
            currentTimeInternal = progress.currentTime
            durationInternal = progress.duration
            emitEvent(.progress(progress))

        case .failed(let error):
            try? fail(error)

        default:
            break
        }
    }
}

    
extension PlayerActor {

    /// Public API: external commands
    func handle(_ intent: PlayerIntent) async throws {

        lastUserIntent = intent

        switch intent {

        case .load(let source):
            try transition(to: .loading)
            currentSource = source

            do {
                try await player.load(source)
            } catch {
                try fail(error)
                throw error
            }

        case .play:
            guard state.isPlayable else { return }

            player.play()
            try transition(to: .playing)
            emitEvent(.playbackStarted)

        case .pause:
            guard state == .playing else { return }

            player.pause()
            try transition(to: .paused)
            emitEvent(.playbackPaused)

        case .seek(let seconds):
            guard state.isSeekable else { return }

            emitEvent(.seekStarted(seconds))

            do {
                try await player.seek(to: seconds)
                emitEvent(.seekCompleted(seconds))
            } catch {
                emitEvent(.seekFailed(PlayerError.from(error)))
            }

        case .stop:
            player.stop()
            try transition(to: .idle)
            emitEvent(.stopped)

        case .release:
            player.release()
            try transition(to: .idle)
            emitEvent(.released)

        default:
            break
        }
    }
}


    
private extension PlayerActor {

    /// Validates and applies state transitions
    func transition(to newState: PlayerState) throws {
        guard state.canTransition(to: newState) else {
            throw InvalidStateTransition(from: state, to: newState)
        }

        state = newState
        stateEmitter.emit(state)
    }

    /// Handles terminal failure
    func fail(_ error: Error) throws {
        let mapped = PlayerError.from(error)
        try transition(to: .error(mapped))
        emitEvent(.failed(mapped))
    }

    /// Emits external event
    func emitEvent(_ event: PlayerEvent) {
        eventEmitter.emit(event)
    }
}

