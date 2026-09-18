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

    private var reducer = PlaybackStateReducer()
    private var currentSource: MediaSource?

    private var currentTimeInternal: TimeInterval = 0
    private var durationInternal: TimeInterval?

    // MARK: - Initialization

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

        player.onReady = { [weak self] in
            guard let self else { return }

            Task {
                await self.consume(.ready)
            }
        }

        player.onBuffering = { [weak self] buffering in
            guard let self else { return }

            Task {
                await self.consume(
                    buffering
                        ? .bufferingStarted
                        : .bufferingEnded
                )
            }
        }

        player.onCompletion = { [weak self] in
            guard let self else { return }

            Task {
                await self.consume(.playbackCompleted)
            }
        }

        player.onError = { [weak self] error in
            guard let self else { return }

            Task {
                await self.consume(
                    .failed(
                        PlayerError.from(error)
                    )
                )
            }
        }

        player.onProgress = { [weak self] progress in
            guard let self else { return }

            Task {
                await self.consume(
                    .progress(progress)
                )
            }
        }
    }

    deinit {
        player.release()
    }

    // MARK: - Snapshots

    var currentState: PlayerState {
        reducer.state
    }

    var currentTime: TimeInterval {
        currentTimeInternal
    }

    var duration: TimeInterval? {
        durationInternal
    }

    // MARK: - Event Consumption

    private func consume(
        _ event: PlayerActorEvent
    ) async {

        switch event {

        case .ready:

            apply(.ready)

            emit(.ready)

            if config.autoPlay {
                try? await handle(.play)
            }

        case .bufferingStarted:

            apply(.bufferingStarted)

            emit(.bufferingStarted)

        case .bufferingEnded:

            apply(.bufferingEnded)

            emit(.bufferingEnded)

        case .playbackCompleted:

            apply(.playbackCompleted)

            emit(.playbackCompleted)

            if config.looping {
                try? await replayFromBeginning()
            }

        case .progress(let progress):

            currentTimeInternal = progress.currentTime
            durationInternal = progress.duration

            emit(.progress(progress))

        case .failed(let error):

            handlePlaybackFailure(error)
        }
    }

    // MARK: - Public Intent Handling

    func handle(
        _ intent: PlayerIntent
    ) async throws {

        switch intent {

        case .load(let source):

            apply(.loadStarted)

            currentSource = source

            do {
                try await player.load(source)
            } catch {
                handlePlaybackFailure(error)
                throw error
            }

        case .play:

            guard reducer.state.isPlayable else {
                return
            }

            if reducer.state == .ended {
                try await player.seek(to: 0)
            }

            try applyAndPerform(
                .play
            ) {
                player.play()
            }

            emit(.playbackStarted)

        case .pause:

            guard reducer.state == .playing else {
                return
            }

            try applyAndPerform(
                .pause
            ) {
                player.pause()
            }

            emit(.playbackPaused)

        case .seek(let seconds):

            guard reducer.state.isSeekable else {
                return
            }

            emit(
                .seekStarted(seconds)
            )

            do {
                try await player.seek(
                    to: max(0, seconds)
                )

                emit(
                    .seekCompleted(seconds)
                )

            } catch {
                emit(
                    .seekFailed(
                        PlayerError.from(error)
                    )
                )

                throw error
            }

        case .stop:

            player.stop()

            apply(.reset)

            emit(.stopped)

        case .release:

            player.release()

            apply(.released)

            emit(.released)

        default:
            break
        }
    }

    // MARK: - State Helpers

    private func apply(
        _ event: PlaybackStateReducer.Event
    ) {
        let previous = reducer.state

        let newState = reducer.reduce(event)

        guard newState != previous else {
            return
        }

        stateEmitter.emit(newState)
    }

    private func applyAndPerform(
        _ event: PlaybackStateReducer.Event,
        operation: () -> Void
    ) throws {

        let previous = reducer.state

        let newState = reducer.reduce(event)

        guard newState != previous else {
            return
        }

        operation()

        stateEmitter.emit(newState)
    }

    private func handlePlaybackFailure(
        _ error: Error
    ) {

        handlePlaybackFailure(
            PlayerError.from(error)
        )
    }

    private func handlePlaybackFailure(
        _ error: PlayerError
    ) {

        switch error {

        case .network:

            apply(.networkLost)

            emit(.failed(error))

        default:

            apply(
                .failed(error)
            )

            emit(
                .failed(error)
            )
        }
    }

    private func replayFromBeginning() async throws {

        try await player.seek(
            to: 0
        )

        apply(.play)

        player.play()

        emit(.playbackStarted)
    }

    private func emit(
        _ event: PlayerEvent
    ) {
        eventEmitter.emit(event)
    }
}

// MARK: - Internal Actor Events

private enum PlayerActorEvent {

    case ready

    case bufferingStarted

    case bufferingEnded

    case playbackCompleted

    case failed(PlayerError)

    case progress(PlaybackProgress)
}

// MARK: - AV Error → Actor Event Bridge

private extension PlayerActor {

    func consume(
        _ event: PlayerActorEvent
    ) async {
        // This overload exists only to make the callback bridge explicit.
        await consumeInternal(event)
    }

    func consumeInternal(
        _ event: PlayerActorEvent
    ) async {

        switch event {

        case .ready:

            apply(.ready)

            emit(.ready)

            if config.autoPlay {
                try? await handle(.play)
            }

        case .bufferingStarted:

            apply(.bufferingStarted)
            emit(.bufferingStarted)

        case .bufferingEnded:

            apply(.bufferingEnded)
            emit(.bufferingEnded)

        case .playbackCompleted:

            apply(.playbackCompleted)
            emit(.playbackCompleted)

            if config.looping {
                try? await replayFromBeginning()
            }

        case .failed(let error):

            handlePlaybackFailure(error)

        case .progress(let progress):

            currentTimeInternal = progress.currentTime
            durationInternal = progress.duration

            emit(.progress(progress))
        }
    }
}
