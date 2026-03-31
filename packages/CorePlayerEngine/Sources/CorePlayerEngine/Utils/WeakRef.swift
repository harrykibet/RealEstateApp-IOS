//
//  WeakRef.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

/// Weak reference wrapper to avoid retain cycles in collections.
///
/// Useful when:
/// - Storing delegates
/// - Keeping weak references in arrays/dictionaries
///
/// Example:
/// ```swift
/// let weakRef = WeakRef(object)
/// weakRef.value // optional
/// ```
public final class WeakRef<T: AnyObject> {
    
    public weak var value: T?
    
    public init(_ value: T?) {
        self.value = value
    }
}
