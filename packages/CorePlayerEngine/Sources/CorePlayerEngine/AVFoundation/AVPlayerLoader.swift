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
    
    // MARK: Public
    
    func load(_ source: MediaSource) async throws {
        
        let item = try await loader.load(source)
        
        try await withCheckedThrowingContinuation { continuation in
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
                
                continuation.resume()
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

private extension AVPlayerLoader {
    
    func loadKeys(_ keys: [String], for asset: AVURLAsset) async throws {
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            
            for key in keys {
                group.addTask {
                    try await asset.loadValue(forKey: key)
                    
                    var error: NSError?
                    let status = asset.statusOfValue(forKey: key, error: &error)
                    
                    if status == .failed || status == .cancelled {
                        throw error ?? PlayerError.invalidSource
                    }
                }
            }
            
            try await group.waitForAll()
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
