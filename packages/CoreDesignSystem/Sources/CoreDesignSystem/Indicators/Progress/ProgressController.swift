//
//  ProgressController.swift
//  CoreDesignSystem
//
//  Created by builder on 4/20/26.
//


import Foundation

public actor ProgressController: Sendable {

    // MARK: - State
    
    private var state: EstatiaProgressState = .idle
    
    // MARK: - Observability
    
    private var continuations: [UUID: AsyncStream<EstatiaProgressState>.Continuation] = [:]
    
    public init(initial: EstatiaProgressState = .idle) {
        self.state = initial
    }
}

public extension ProgressController {
    
    func stream() -> AsyncStream<EstatiaProgressState> {
        AsyncStream { continuation in
            let id = UUID()
            continuations[id] = continuation
            
            continuation.yield(state)
            
            continuation.onTermination = { [weak self] _ in
                Task {
                    await self?.removeContinuation(id)
                }
            }
        }
    }
    
    private func removeContinuation(_ id: UUID) {
        continuations.removeValue(forKey: id)
    }
}

public extension ProgressController {

    func send(_ event: ProgressEvent) {
        let newState = ProgressReducer.reduce(
            state: state,
            event: event
        )
        
        guard newState != state else { return }
        
        state = newState
        broadcast(state)
    }
}

private extension ProgressController {

    func broadcast(_ state: EstatiaProgressState) {
        for continuation in continuations.values {
            continuation.yield(state)
        }
    }
}

public extension ProgressController {

    func start() {
        send(.startIndeterminate)
    }
    
    func startDeterminate() {
        send(.startDeterminate)
    }
    
    func update(_ value: Double) {
        send(.updateProgress(value))
    }
    
    func updateBuffered(progress: Double, buffer: Double) {
        send(.updateBuffered(progress: progress, buffer: buffer))
    }
    
    func complete() {
        send(.complete)
    }
    
    func fail(_ error: Error? = nil) {
        send(.fail(error))
    }
    
    func reset() {
        send(.reset)
    }
}
