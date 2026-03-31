//
//  PlayerEventEmitter.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

// MARK: - PlayerEventEmitter

@available(iOS 13.0, *)
public final class PlayerEventEmitter<T: Sendable> {
    
    // MARK: Internal Storage
    
    private struct Subscriber {
        let id: UUID
        let continuation: AsyncStream<T>.Continuation
    }
    
    private var subscribers: [UUID: Subscriber] = [:]
    
    private let lock = NSLock()
    
    // MARK: Init
    
    public init() {}
}

@available(iOS 13.0, *)
public extension PlayerEventEmitter {
    
    var stream: AsyncStream<T> {
        AsyncStream { continuation in
            
            let id = UUID()
            
            let subscriber = Subscriber(
                id: id,
                continuation: continuation
            )
            
            add(subscriber)
            
            continuation.onTermination = { [weak self] _ in
                self?.remove(id)
            }
        }
    }
}

@available(iOS 13.0, *)
public extension PlayerEventEmitter {
    
    func emit(_ value: T) {
        lock.lock()
        let currentSubscribers = subscribers.values
        lock.unlock()
        
        for subscriber in currentSubscribers {
            subscriber.continuation.yield(value)
        }
    }
}

@available(iOS 13.0, *)
private extension PlayerEventEmitter {
    
    private func add(_ subscriber: Subscriber) {
        lock.lock()
        subscribers[subscriber.id] = subscriber
        lock.unlock()
    }
    
    func remove(_ id: UUID) {
        lock.lock()
        subscribers.removeValue(forKey: id)
        lock.unlock()
    }
}
