//
//  FeedPlaybackItem.swift
//  CorePlayerEngine
//
//  Created by builder on 9/20/26.
//


import Foundation

public struct FeedPlaybackItem: Sendable, Equatable {

    public let mediaId: String
    public let source: MediaSource
    public let matchScore: Double

    public let title: String?
    public let artist: String?

    public init(
        mediaId: String,
        source: MediaSource,
        matchScore: Double = 0.5,
        title: String? = nil,
        artist: String? = nil
    ) {
        self.mediaId = mediaId
        self.source = source
        self.matchScore = matchScore
        self.title = title
        self.artist = artist
    }
}