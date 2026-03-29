//
//  AVPlayerLoader.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation
import AVFoundation

// MARK: - AVPlayerLoader

final class AVPlayerLoader {
    
    private let queue = DispatchQueue(label: "com.coreplayerengine.avplayerloader")
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var playerTimeObserverToken: Any?
    private var playerObservers: [NSKeyValueObservation] = []
    private var itemObservers: [NSKeyValueObservation] = []
    
    // MARK: Public
    
    @available(iOS 13.0, *)
    func load(_ source: MediaSource) async throws {
        
        // Create and prepare asset
        let asset = try await createAsset(from: source)
        try await prepare(asset: asset)
        
        let item = AVPlayerItem(asset: asset)
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            queue.async { [weak self] in
                guard let self else {
                    continuation.resume(throwing: PlayerError.unknown)
                    return
                }
                
                self.cleanup()
                
                self.playerItem = item
                self.player = AVPlayer(playerItem: item)
                
                self.setupObservers(for: item)
                self.setupTimeObserver()
                
                continuation.resume(returning: ())
            }
        }
    }
}

private extension AVPlayerLoader {
    
    func createAsset(from source: MediaSource) async throws -> AVURLAsset {
        
        var options: [String: Any] = [:]
        
        // Inject HTTP headers if present
        if let headers = source.headers {
            options["AVURLAssetHTTPHeaderFieldsKey"] = headers
        }
        
        let asset = AVURLAsset(url: source.url, options: options)
        
        return asset
    }
}

@available(iOS 13.0, *)
private extension AVPlayerLoader {
    
    func prepare(asset: AVURLAsset) async throws {
        
        let requiredKeys = [
            "playable",
            "duration",
            "tracks"
        ]
        
        try await loadKeys(requiredKeys, for: asset)
        
        try validate(asset: asset)
    }
}

@available(iOS 13.0, *)
private extension AVPlayerLoader {
    
    func loadKeys(_ keys: [String], for asset: AVURLAsset) async throws {
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            asset.loadValuesAsynchronously(forKeys: keys) {
                var firstError: Error?
                for key in keys {
                    var error: NSError?
                    let status = asset.statusOfValue(forKey: key, error: &error)
                    switch status {
                    case .loaded:
                        continue
                    case .failed, .cancelled:
                        firstError = error ?? PlayerError.invalidSource
                        break
                    default:
                        // Should not happen here, treat as failure
                        firstError = error ?? PlayerError.invalidSource
                        break
                    }
                }
                if let err = firstError {
                    continuation.resume(throwing: err)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}

private extension AVPlayerLoader {
    
    func validate(asset: AVURLAsset) throws {
        
        // Must be playable
        guard asset.isPlayable else {
            throw PlayerError.unsupportedFormat
        }
        
        // Must have at least one track
        guard !asset.tracks.isEmpty else {
            throw PlayerError.invalidSource
        }
    }
}
private extension AVPlayerLoader {
    func cleanup() {
        // Remove KVO observers
        playerObservers.forEach { $0.invalidate() }
        playerObservers.removeAll()
        itemObservers.forEach { $0.invalidate() }
        itemObservers.removeAll()
        
        // Remove time observer
        if let player = player, let token = playerTimeObserverToken {
            player.removeTimeObserver(token)
        }
        playerTimeObserverToken = nil
        
        // Clear current item from player
        player?.replaceCurrentItem(with: nil)
        playerItem = nil
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
    }
    
    func setupObservers(for item: AVPlayerItem) {
        guard let player = player else { return }
        
        // Observe player status-related properties
        let obs1 = player.observe(\AVPlayer.timeControlStatus, options: [.initial, .new]) { [weak self] player, _ in
            self?.handleTimeControlStatusChange(player.timeControlStatus)
        }
        let obs2 = player.observe(\AVPlayer.rate, options: [.initial, .new]) { [weak self] player, _ in
            self?.handleRateChange(player.rate)
        }
        playerObservers.append(contentsOf: [obs1, obs2])
        
        // Observe item status and buffering
        let o1 = item.observe(\AVPlayerItem.status, options: [.initial, .new]) { [weak self] item, _ in
            self?.handleItemStatusChange(item.status)
        }
        let o2 = item.observe(\AVPlayerItem.loadedTimeRanges, options: [.new]) { [weak self] item, _ in
            self?.handleLoadedTimeRanges(item.loadedTimeRanges)
        }
        let o3 = item.observe(\AVPlayerItem.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] item, _ in
            self?.handleLikelyToKeepUp(item.isPlaybackLikelyToKeepUp)
        }
        itemObservers.append(contentsOf: [o1, o2, o3])
        
        // Notifications for end and failure
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(itemDidPlayToEnd(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: item)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(itemFailedToPlayToEnd(_:)),
                                               name: .AVPlayerItemFailedToPlayToEndTime,
                                               object: item)
    }
    
    func setupTimeObserver() {
        guard let player = player else { return }
        
        // Remove existing time observer if any
        if let token = playerTimeObserverToken {
            player.removeTimeObserver(token)
            playerTimeObserverToken = nil
        }
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        playerTimeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: queue) { [weak self] time in
            self?.handlePeriodicTimeUpdate(time)
        }
    }
}

private extension AVPlayerLoader {
    func handleTimeControlStatusChange(_ status: AVPlayer.TimeControlStatus) {
        // Hook for client: buffering/playing/paused
        // e.g., delegate or notification
    }
    
    func handleRateChange(_ rate: Float) {
        // Hook for client: playback speed changed
    }
    
    func handleItemStatusChange(_ status: AVPlayerItem.Status) {
        // Hook for client: readyToPlay/failed/unknown
    }
    
    func handleLoadedTimeRanges(_ ranges: [NSValue]) {
        // Hook for client: update buffer progress
    }
    
    func handleLikelyToKeepUp(_ keepUp: Bool) {
        // Hook for client: buffering state changed
    }
    
    @objc func itemDidPlayToEnd(_ note: Notification) {
        // Hook for client: playback finished
    }
    
    @objc func itemFailedToPlayToEnd(_ note: Notification) {
        // Hook for client: playback failed near end
    }
    
    func handlePeriodicTimeUpdate(_ time: CMTime) {
        // Hook for client: current playback time update
    }
}

