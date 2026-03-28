//
//  PlayerActor.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

@available(iOS 13.0, *)
actor PlayerActor {
    
    // MARK: Dependencies
    
    private let config: PlayerConfiguration
    private let player: AVPlayerWrapper
    private let stateEmitter: PlayerEventEmitter<PlayerState>
    private let eventEmitter: PlayerEventEmitter<PlayerEvent>
    
    // MARK: State
    
    private var state: PlayerState = .idle
    private var currentSource: MediaSource?
    
    private var currentTimeInternal: TimeInterval = 0
    private var durationInternal: TimeInterval?
    
    
    // MARK: Init
    
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
        
        bindCallbacks()
    }
}

@available(iOS 13.0, *)
private extension PlayerActor {
    
    func bindCallbacks() {
        
        player.onReady = { [weak self] in
            Task { await self?.handle(.ready) }
        }
        
        player.onBuffering = { [weak self] buffering in
            Task { await self?.handle(.buffering(buffering)) }
        }
        
        player.onCompletion = { [weak self] in
            Task { await self?.handle(.completed) }
        }
        
        player.onError = { [weak self] error in
            Task { await self?.handle(.failed(error)) }
        }
        
        player.onProgress = { [weak self] progress in
            Task { await self?.handle(.progress(progress)) }
        }
    }
}

@available(iOS 13.0, *)
extension PlayerActor {
    
    func handle(_ intent: PlayerIntent) async throws {
        
        switch intent {
            
        // MARK: Load
            
        case .load(let source):
            try transition(to: .loading)
            currentSource = source
            
            do {
                try await player.load(source)
            } catch {
                try fail(error)
                throw error
            }
            
            
        // MARK: Ready
            
        case .ready:
            try transition(to: .ready)
            emitEvent(.ready)
            
            if config.autoPlay {
                await handle(.play)
            }
            
            
        // MARK: Play
            
        case .play:
            guard state.isPlayable else { return }
            
            try transition(to: .playing)
            player.play()
            emitEvent(.playbackStarted)
            
            
        // MARK: Pause
            
        case .pause:
            guard state == .playing else { return }
            
            try transition(to: .paused)
            player.pause()
            emitEvent(.playbackPaused)
            
            
        // MARK: Buffering
            
        case .buffering(let isBuffering):
            if isBuffering {
                try transition(to: .buffering)
                emitEvent(.bufferingStarted)
            } else {
                try transition(to: .playing)
                emitEvent(.bufferingEnded)
            }
            
            
        // MARK: Completion
            
        case .completed:
            try transition(to: .ended)
            emitEvent(.playbackCompleted)
            
            if config.looping {
                await handle(.play)
            }
            
            
        // MARK: Seek
            
        case .seek(let seconds):
            guard state.isSeekable else { return }
            
            emitEvent(.seekStarted(seconds))
            
            do {
                try await player.seek(to: seconds)
                emitEvent(.seekCompleted(seconds))
            } catch {
                emitEvent(.seekFailed(PlayerError.from(error)))
            }
            
            
        // MARK: Stop
            
        case .stop:
            player.stop()
            try transition(to: .idle)
            emitEvent(.stopped)
            
            
        // MARK: Release
            
        case .release:
            player.release()
            try transition(to: .idle)
            emitEvent(.released)
            
            
        // MARK: Error
            
        case .failed(let error):
            try fail(error)
            
            
        // MARK: Progress
            
        case .progress(let progress):
            currentTimeInternal = progress.currentTime
            durationInternal = progress.duration
            emitEvent(.progress(progress))
        }
    }
}

@available(iOS 13.0, *)
private extension PlayerActor {
    
    func transition(to newState: PlayerState) throws {
        guard state.canTransition(to: newState) else {
            throw InvalidStateTransition(from: state, to: newState)
        }
        
        state = newState
        stateEmitter.emit(state)
    }
    
    
    func fail(_ error: Error) throws {
        let mapped = PlayerError.from(error)
        try transition(to: .error(mapped))
        emitEvent(.failed(mapped))
    }
    
    
    func emitEvent(_ event: PlayerEvent) {
        eventEmitter.emit(event)
    }
}
