//
//  AVPlayerWrapper.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation
import AVFoundation

// MARK: - AVPlayerWrapper

    
final class AVPlayerWrapper: @unchecked Sendable {
    // MARK: Callbacks (Bridged to Engine)
    
    var onReady: (@MainActor @Sendable () -> Void)?
    var onBuffering: (@MainActor @Sendable (Bool) -> Void )?
    var onCompletion: (@MainActor @Sendable () -> Void)?
    var onError: (@MainActor @Sendable (Error) -> Void)?
    var onProgress: (@MainActor @Sendable (PlaybackProgress) -> Void)?
    
    // MARK: Private
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    private let itemObserver = AVPlayerItemObserver()
    private let timeObserver: AVPlayerTimeObserver
    
    private let queue = DispatchQueue(label: "player.wrapper.queue")
    
    private let progressInterval: TimeInterval
    
    // MARK: Init
    
    init(progressInterval: TimeInterval) {
        self.progressInterval = progressInterval
        self.timeObserver = AVPlayerTimeObserver(interval: progressInterval, queue: queue)
    }
    
    deinit {
        itemObserver.detach()
        timeObserver.detach()
    }
}

    
extension AVPlayerWrapper {
    nonisolated(nonsending) func load(_ source: MediaSource) async throws {
        try await queue.sync {
            cleanup()
            
            let asset = AVURLAsset(url: source.url)
            let item = AVPlayerItem(asset: asset)
            self.playerItem = item
            let player = AVPlayer(playerItem: item)
            self.player = player
            
            itemObserver.attach(to: item)
            timeObserver.attach(player: player, item: item)
            
            itemObserver.onReady = { [weak self] in
                self?.dispatch { self?.onReady?() }
            }
            
            itemObserver.onBuffering = { [weak self] buffering in
                self?.dispatch { self?.onBuffering?(buffering) }
            }
            
            itemObserver.onCompletion = { [weak self] in
                self?.dispatch { self?.onCompletion?() }
            }
            
            itemObserver.onError = { [weak self] error in
                self?.dispatch { self?.onError?(error) }
            }
            
            timeObserver.onProgress = { [weak self] progress in
                self?.dispatch { self?.onProgress?(progress) }
            }
        }
    }
}

    
extension AVPlayerWrapper {
    
    func play() {
        queue.async { [weak self] in
            self?.player?.play()
        }
    }
    
    func pause() {
        queue.async { [weak self] in
            self?.player?.pause()
        }
    }
    
    func stop() {
        queue.async { [weak self] in
            self?.player?.pause()
            self?.seekToStart()
        }
    }
    
        
    nonisolated(nonsending) func seek(to seconds: TimeInterval) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            queue.async { [weak self] in
                guard let self, let player = self.player else {
                    continuation.resume(throwing: PlayerError.seekFailed)
                    return
                }
                
                let time = CMTime(seconds: seconds, preferredTimescale: 600)
                
                player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) { finished in
                    if finished {
                        continuation.resume()
                    } else {
                        continuation.resume(throwing: PlayerError.seekFailed)
                    }
                }
            }
        }
    }
}

    
extension AVPlayerWrapper {
    
    func release() {
        queue.sync {
            cleanup()
        }
    }
    
    private func cleanup() {
        itemObserver.detach()
        timeObserver.detach()
        
        player?.pause()
        player = nil
        playerItem = nil
    }
}

    
private extension AVPlayerWrapper {
    
        
    func dispatch(_ block: @MainActor @Sendable @escaping () -> Void) {
        Task { @MainActor [block] in
            block()
        }
    }
    
    func seekToStart() {
        player?.seek(to: .zero)
    }
}

