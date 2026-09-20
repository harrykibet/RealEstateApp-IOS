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
    case retryExhausted
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

        if let playerError = error as? PlayerError {
            return playerError
        }

        let nsError = error as NSError

        if nsError.domain == NSURLErrorDomain {
            return mapNetworkError(nsError)
        }

        // AVFoundation often wraps transport failures inside an underlying
        // NSError. Inspect that before classifying the failure as decoding.
        if let underlying = nsError.userInfo[
            NSUnderlyingErrorKey
        ] as? NSError {

            if underlying.domain == NSURLErrorDomain {
                return mapNetworkError(underlying)
            }
        }

        if nsError.domain == AVError.errorDomain {
            return .decodingFailed
        }

        return .system(
            SystemError(
                domain: nsError.domain,
                code: nsError.code
            )
        )
    }
}

private extension PlayerError {

    static func mapNetworkError(
        _ error: NSError
    ) -> PlayerError {

        switch error.code {

        case NSURLErrorNotConnectedToInternet,
             NSURLErrorDataNotAllowed,
             NSURLErrorNetworkConnectionLost:
            return .network(.offline)

        case NSURLErrorTimedOut:
            return .network(.timeout)

        case NSURLErrorCannotFindHost,
             NSURLErrorCannotConnectToHost,
             NSURLErrorDNSLookupFailed:
            return .network(.unreachable)

        case NSURLErrorCannotLoadFromNetwork:
            return .network(.unknown)

        default:
            return .network(.unknown)
        }
    }
}

