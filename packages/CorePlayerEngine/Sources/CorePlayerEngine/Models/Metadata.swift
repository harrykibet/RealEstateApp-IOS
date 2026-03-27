//
//  Metadata.swift
//  CorePlayerEngine
//
//  Created by builder on 3/27/26.
//

import Foundation


// MARK: - Metadata

public struct Metadata: Equatable, Sendable {
    
    public let title: String?
    public let subtitle: String?
    public let artworkURL: URL?
    
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        artworkURL: URL? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.artworkURL = artworkURL
    }
}
