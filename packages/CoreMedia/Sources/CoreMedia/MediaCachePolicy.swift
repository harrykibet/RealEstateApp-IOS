//
//  MediaCachePolicy.swift
//  CoreMedia
//
//  Created by builder on 4/27/26.
//

import Foundation

public struct MediaCachePolicy: Sendable, Equatable {
    
    public enum Read: Sendable, Equatable {
        case none                // Skip all caches
        case memory              // Memory only
        case disk                // Disk only
        case memoryThenDisk      // Default fast path
    }
    
    public enum Write: Sendable, Equatable {
        case none
        case memory
        case disk
        case memoryAndDisk
    }
    
    public enum Expiration: Sendable, Equatable {
        case never
        case seconds(TimeInterval)
        case date(Date)
    }
    
    public let read: Read
    public let write: Write
    public let expiration: Expiration
    
    public init(
        read: Read,
        write: Write,
        expiration: Expiration = .never
    ) {
        self.read = read
        self.write = write
        self.expiration = expiration
    }
}

public extension MediaCachePolicy {
    
    static let `default` = MediaCachePolicy(
        read: .memoryThenDisk,
        write: .memoryAndDisk,
        expiration: .seconds(60 * 60 * 24) // 1 day
    )
    
    static let aggressive = MediaCachePolicy(
        read: .memoryThenDisk,
        write: .memoryAndDisk,
        expiration: .never
    )
    
    static let reloadIgnoringCache = MediaCachePolicy(
        read: .none,
        write: .memoryAndDisk,
        expiration: .never
    )
    
    static let memoryOnly = MediaCachePolicy(
        read: .memory,
        write: .memory,
        expiration: .never
    )
    
    static let noCache = MediaCachePolicy(
        read: .none,
        write: .none,
        expiration: .never
    )
}
