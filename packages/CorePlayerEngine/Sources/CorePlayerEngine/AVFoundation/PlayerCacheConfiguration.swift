//
//  PlayerCacheConfiguration.swift
//  CorePlayerEngine
//
//  Created by builder on 9/23/26.
//


//
//  PlayerCacheConfiguration.swift
//  CorePlayerEngine
//

import Foundation

@available(iOS 18.0, macOS 10.15, *)
struct PlayerCacheConfiguration: Sendable {

    let store: FileMediaCacheStore

    let fetcher: MediaDataFetching

    let keyFactory: MediaCacheKeyProviding

    /// Maximum amount loaded by one AVAsset resource request before
    /// yielding back to AVFoundation.
    let requestChunkSize: Int

    init(
        store: FileMediaCacheStore,
        fetcher: MediaDataFetching = URLSessionMediaDataFetcher(),
        keyFactory: MediaCacheKeyProviding =
            DefaultMediaCacheKeyFactory(),
        requestChunkSize: Int = 512 * 1024
    ) {
        precondition(
            requestChunkSize > 0
        )

        self.store = store
        self.fetcher = fetcher
        self.keyFactory = keyFactory
        self.requestChunkSize = requestChunkSize
    }
}