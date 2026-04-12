//
//  AVPlayerLoader.swift
//  CorePlayerEngine
//
//  Responsibility:
//  - Creates and prepares AVPlayer + AVPlayerItem
//  - Wires observers → emits PlayerEvent
//  - Owns lifecycle of player resources
//
//  Design:
//  - Single entry point: load()
//  - Deterministic cleanup before reloading
//  - No UI/thread assumptions
//

import Foundation
import AVFoundation

final class AVPlayerLoader {

    // MARK: - Event Sink

    var emit: ((PlayerEvent) -> Void)?

    // MARK: - Dependencies

    private let queue = DispatchQueue(label: "com.coreplayerengine.loader")

    private let itemObserver = AVPlayerItemObserver()
    private let timeObserver = AVPlayerTimeObserver(interval: 0.5, queue: .global())

    // MARK: - State

    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?

    // MARK: - Public API

        
    func load(_ source: MediaSource) async throws {

        let asset = try await createAsset(from: source)
        try await prepare(asset: asset)

        let item = AVPlayerItem(asset: asset)

        cleanup()

        let player = AVPlayer(playerItem: item)

        self.player = player
        self.playerItem = item

        wireObservers(player: player, item: item)

        emit?(.ready)
    }

    func getPlayer() -> AVPlayer? {
        player
    }

    func release() {
        cleanup()
        emit?(.released)
    }
}

// MARK: - Wiring

private extension AVPlayerLoader {

    func wireObservers(player: AVPlayer, item: AVPlayerItem) {

        itemObserver.emit = { [weak self] event in
            self?.emit?(event)
        }

        timeObserver.emit = { [weak self] event in
            self?.emit?(event)
        }

        itemObserver.attach(to: item)
        timeObserver.attach(player: player, item: item)
    }
}

// MARK: - Asset Pipeline

private extension AVPlayerLoader {

    func createAsset(from source: MediaSource) async throws -> AVURLAsset {

        var options: [String: Any] = [:]

        if let headers = source.headers {
            options["AVURLAssetHTTPHeaderFieldsKey"] = headers
        }

        return AVURLAsset(url: source.url, options: options)
    }

        
    func prepare(asset: AVURLAsset) async throws {

        let keys = ["playable", "duration", "tracks"]

        try await withCheckedThrowingContinuation { continuation in
            asset.loadValuesAsynchronously(forKeys: keys) {
                var error: NSError?

                for key in keys {
                    let status = asset.statusOfValue(forKey: key, error: &error)

                    if status != .loaded {
                        continuation.resume(
                            throwing: error ?? PlayerError.invalidSource
                        )
                        return
                    }
                }

                continuation.resume()
            }
        }

        guard asset.isPlayable else {
            throw PlayerError.unsupportedFormat
        }

        guard !asset.tracks.isEmpty else {
            throw PlayerError.invalidSource
        }
    }
}

// MARK: - Cleanup

private extension AVPlayerLoader {

    func cleanup() {
        itemObserver.detach()
        timeObserver.detach()

        player?.replaceCurrentItem(with: nil)

        playerItem = nil
        player = nil
    }
}
