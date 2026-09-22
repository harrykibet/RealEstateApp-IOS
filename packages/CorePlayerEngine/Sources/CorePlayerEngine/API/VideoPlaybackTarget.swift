//
//  VideoPlaybackTarget.swift
//  CorePlayerEngine
//
//  Created by builder on 9/22/26.
//


import Foundation

@MainActor
public protocol VideoPlaybackTarget: AnyObject {

    var activeMediaId: String? { get }

    func play(
        mediaId: String,
        source: MediaSource
    ) async throws

    func preload(
        mediaId: String,
        source: MediaSource
    ) async

    func updateComposedMedia(
        _ mediaIds: Set<String>
    ) async

    func observeState(
        mediaId: String
    ) async -> AsyncStream<PlayerState>?

    func isMediaActive(
        _ mediaId: String
    ) -> Bool

    func pauseCurrent() async
}

extension PlaybackOrchestrator:
    VideoPlaybackTarget {}