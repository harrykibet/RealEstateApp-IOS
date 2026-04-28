//
//  MediaError.swift
//  CoreMedia
//
//  Created by builder on 4/27/26.
//

public enum MediaError: Error, Sendable, Equatable {
    
    case invalidURL
    case requestFailed(underlying: Error)
    case invalidResponse
    case unacceptableStatusCode(Int)
    case emptyData
    case corruptedData
    case decodingFailed(underlying: Error)
    case cacheMiss
    case cacheWriteFailed
    case cacheReadFailed
    case cancelled
    case unknown(underlying: Error?)
    
    public static func == (lhs: MediaError, rhs: MediaError) -> Bool {
        switch (lhs, rhs) {
            
        case (.invalidURL, .invalidURL):
            return true
            
        case (.invalidResponse, .invalidResponse):
            return true
            
        case (.emptyData, .emptyData):
            return true
            
        case (.corruptedData, .corruptedData):
            return true
            
        case (.cacheMiss, .cacheMiss):
            return true
            
        case (.cacheWriteFailed, .cacheWriteFailed):
            return true
            
        case (.cacheReadFailed, .cacheReadFailed):
            return true
            
        case (.cancelled, .cancelled):
            return true
            
        case (.requestFailed, .requestFailed):
            return true   // ignore underlying
            
        case (.decodingFailed, .decodingFailed):
            return true   // ignore underlying
            
        case let (.unacceptableStatusCode(a), .unacceptableStatusCode(b)):
            return a == b
            
        case (.unknown, .unknown):
            return true   // ignore underlying
            
        default:
            return false
        }
    }
}
