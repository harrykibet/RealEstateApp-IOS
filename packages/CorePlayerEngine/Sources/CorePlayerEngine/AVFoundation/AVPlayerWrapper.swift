//
//  AVPlayerWrapper.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation
import AVFoundation

// MARK: - AVPlayerWrapper

@available(iOS 13.0, *)
@MainActor
final class AVPlayerWrapper {
    // MARK: Callbacks (Bridged to Engine)
    
    var onReady: (@MainActor @Sendable () -> Void)?
    var onBuffering: (@MainActor @Sendable (Bool) -> Void )?
    var onCompletion: (@MainActor @Sendable () -> Void)?
    var onError: (@MainActor @Sendable (Error) -> Void)?
    var onProgress: (@MainActor @Sendable (PlaybackProgress) -> Void)?
    
    // MARK: Private
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    private var timeObserver: Any?
    private var statusObserver: NSKeyValueObservation?
    private var bufferObserver: NSKeyValueObservation?
    
    private let queue = DispatchQueue(label: "player.wrapper.queue")
    
    private var isBuffering = false
    
    private let progressInterval: TimeInterval
    
    // MARK: Init
    
    init(progressInterval: TimeInterval) {
        self.progressInterval = progressInterval
    }
    
    
    @objc
    private func didFinish() {
        dispatch { self.onCompletion?() }
    }
}

@available(iOS 13.0, *)
extension AVPlayerWrapper {
    func load(_ source: MediaSource) async throws {
        try await queue.sync {
            cleanup()
            
            let asset = AVURLAsset(url: source.url)
            let item = AVPlayerItem(asset: asset)
            
            self.playerItem = item
            self.player = AVPlayer(playerItem: item)
            
            setupObservers(for: item)
            setupTimeObserver()
        }
    }
}

@available(iOS 13.0, *)
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
    
    @available(iOS 13.0, *)
    func seek(to seconds: TimeInterval) async throws {
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

@available(iOS 13.0, *)
private extension AVPlayerWrapper {
    
    func setupObservers(for item: AVPlayerItem) {
        
        statusObserver = item.observe(\.status, options: [.new, .initial]) { [weak self] item, _ in
            guard let self else { return }
            
            switch item.status {
            case .readyToPlay:
                self.dispatch { self.onReady?() }
                
            case .failed:
                if let error = item.error {
                    self.dispatch { self.onError?(error) }
                }
                
            default:
                break
            }
        }
        
        
        bufferObserver = item.observe(\.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] item, _ in
            guard let self else { return }
            
            let buffering = !item.isPlaybackLikelyToKeepUp
            
            if buffering != self.isBuffering {
                self.isBuffering = buffering
                self.dispatch { self.onBuffering?(buffering) }
            }
        }
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: item
        )
    }
}

@available(iOS 13.0, *)
private extension AVPlayerWrapper {
    
    func setupTimeObserver() {
        guard let player else { return }
        
        let interval = CMTime(seconds: progressInterval, preferredTimescale: 600)
        
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: queue
        ) { [weak self] time in
            guard let self, let item = self.playerItem else { return }
            
            let current = time.seconds
            let duration = item.duration.seconds.isFinite ? item.duration.seconds : nil
            
            let buffered = item.loadedTimeRanges
                .compactMap { $0.timeRangeValue }
                .map { $0.start.seconds + $0.duration.seconds }
                .max()
            
            let progress = PlaybackProgress(
                currentTime: current,
                duration: duration,
                buffered: buffered
            )
            
            self.dispatch {
                self.onProgress?(progress)
            }
        }
    }
}

@available(iOS 13.0, *)
extension AVPlayerWrapper {
    
    func release() {
        queue.sync {
            cleanup()
        }
    }
    
    private func cleanup() {
        
        if let observer = timeObserver, let player {
            player.removeTimeObserver(observer)
            timeObserver = nil
        }
        
        statusObserver?.invalidate()
        bufferObserver?.invalidate()
        
        NotificationCenter.default.removeObserver(self)
        
        player?.pause()
        player = nil
        playerItem = nil
        
        isBuffering = false
    }
}

@available(iOS 13.0, *)
private extension AVPlayerWrapper {
    
    @available(iOS 13.0, *)
    func dispatch(_ block: @MainActor @Sendable @escaping () -> Void) {
        block()
    }
    
    func seekToStart() {
        player?.seek(to: .zero)
    }
}

