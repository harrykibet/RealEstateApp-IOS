//
//  PlayerError.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation
import AVFoundation

// MARK: - PlayerError

public enum PlayerError: Error, Equatable, Sendable {
    
    // MARK: Source / Input
    
    /// Invalid or unsupported media source
    case invalidSource
    
    /// Media format not supported by the player
    case unsupportedFormat
    
    
    // MARK: Network
    
    /// Network request failed (timeout, DNS, offline, etc.)
    case network(NetworkError)
    
    
    // MARK: Decoding / Playback
    
    /// Failed to decode media data
    case decodingFailed
    
    /// Playback stalled and could not recover
    case playbackStalled
    
    
    // MARK: Seek
    
    /// Seek operation failed
    case seekFailed
    
    
    // MARK: System
    
    /// Underlying system error (wrapped but abstracted)
    case system(SystemError)
    
    
    // MARK: Unknown
    
    /// Catch-all for unexpected errors
    case unknown
}

// MARK: - NetworkError

public enum NetworkError: Equatable, Sendable {
    case offline
    case timeout
    case serverError(statusCode: Int)
    case unreachable
    case unknown
}

// MARK: - SystemError

public struct SystemError: Equatable, Sendable {
    
    public let domain: String
    public let code: Int
    
    public init(domain: String, code: Int) {
        self.domain = domain
        self.code = code
    }
}

// MARK: - Mapping

public extension PlayerError {
    
    static func from(_ error: Error) -> PlayerError {
        
        let nsError = error as NSError
        
        // MARK: AVFoundation Errors
        
        if nsError.domain == NSURLErrorDomain {
            return mapNetworkError(nsError)
        }
        
        if nsError.domain == AVError.errorDomain {
            return .decodingFailed
        }
        
        // MARK: Fallback
        
        return .system(
            SystemError(domain: nsError.domain, code: nsError.code)
        )
    }
}

private extension PlayerError {
    
    static func mapNetworkError(_ error: NSError) -> PlayerError {
        
        switch error.code {
        case NSURLErrorNotConnectedToInternet:
            return .network(.offline)
            
        case NSURLErrorTimedOut:
            return .network(.timeout)
            
        case NSURLErrorCannotFindHost,
             NSURLErrorCannotConnectToHost:
            return .network(.unreachable)
            
        default:
            return .network(.unknown)
        }
    }
}

