//
//  AVPlayerWrapper.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation
import AVFoundation

// MARK: - AVPlayerWrapper

final class AVPlayerWrapper {
    // MARK: Callbacks (Bridged to Engine)
    
    var onReady: (() -> Void)?
    var onBuffering: ((Bool) -> Void )?
    var onCompletion: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onProgress: ((PlaybackProgress) -> Void)?
    
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
}
