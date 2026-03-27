//
//  MediaSource.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

// MARK: - MediaSource

public struct MediaSource: Equatable, Sendable {
    
    public let url: URL
    public let type: MediaType
    public let headers: [String: String]?
    public let metadata: Metadata?
    
    public init(
        url: URL,
        type: MediaType = .auto,
        headers: [String: String]? = nil,
        metadata: Metadata? = nil
    ) {
        self.url = url
        self.type = type
        self.headers = headers
        self.metadata = metadata
    }
}
