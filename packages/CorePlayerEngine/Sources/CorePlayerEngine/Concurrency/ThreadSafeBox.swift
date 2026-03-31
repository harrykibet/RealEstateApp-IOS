//
//  ThreadSafeBox.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

/// A lightweight thread-safe container for mutable state.
///
/// Use this when:
/// - You need shared mutable state outside an actor
/// - You want low-overhead synchronization (faster than actor for simple cases)
///
/// Avoid using this for complex logic—prefer `actor` instead.
///
/// ⚠️ Important:
/// - Do NOT expose the underlying value directly
/// - Always mutate via `mutate` or `set`
///
/// Example:
/// ```swift
/// let box = ThreadSafeBox<Int>(0)
/// box.mutate { $0 += 1 }
/// let value = box.value
/// ```
public final class ThreadSafeBox<T> {
    
    private var _value: T
    private let lock = NSLock()
    
    public init(_ value: T) {
        self._value = value
    }
    
    /// Thread-safe read
    public var value: T {
        lock.lock()
        defer { lock.unlock() }
        return _value
    }
    
    /// Thread-safe write
    public func set(_ newValue: T) {
        lock.lock()
        _value = newValue
        lock.unlock()
    }
    
    /// Thread-safe mutation
    public func mutate(_ block: (inout T) -> Void) {
        lock.lock()
        block(&_value)
        lock.unlock()
    }
}
