//
//  AVPlayerTimeObserver.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation
import AVFoundation

// MARK: - AVPlayerTimeObserver

final class AVPlayerTimeObserver {
    
    // MARK: Callback
    
    var onProgress: ((PlaybackProgress) -> Void)?
    
    
    // MARK: Private
    
    private weak var player: AVPlayer?
    private weak var item: AVPlayerItem?
    
    private var timeObserverToken: Any?
    
    private let interval: TimeInterval
    private let queue: DispatchQueue
    
    
    // MARK: Init
    
    init(interval: TimeInterval, queue: DispatchQueue) {
        self.interval = interval
        self.queue = queue
    }
}

extension AVPlayerTimeObserver {
    
    func attach(player: AVPlayer, item: AVPlayerItem) {
        detach()
        
        self.player = player
        self.item = item
        
        let cmInterval = CMTime(seconds: interval, preferredTimescale: 600)
        
        timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: cmInterval,
            queue: queue
        ) { [weak self] time in
            self?.handle(time: time)
        }
    }
}

private extension AVPlayerTimeObserver {
    
    func handle(time: CMTime) {
        guard let item else { return }
        
        let current = time.seconds
        
        let duration = item.duration.seconds.isFinite
            ? item.duration.seconds
            : nil
        
        let buffered = item.loadedTimeRanges
            .compactMap { $0.timeRangeValue }
            .map { $0.start.seconds + $0.duration.seconds }
            .max()
        
        let progress = PlaybackProgress(
            currentTime: current,
            duration: duration,
            buffered: buffered
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.onProgress?(progress)
        }
    }
}

extension AVPlayerTimeObserver {
    
    func detach() {
        if let token = timeObserverToken, let player {
            player.removeTimeObserver(token)
        }
        
        timeObserverToken = nil
        player = nil
        item = nil
    }
}
