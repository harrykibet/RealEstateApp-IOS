//
//  AVPlayerItemObserver.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation
import AVFoundation

// MARK: - AVPlayerItemObserver

final class AVPlayerItemObserver {
    
    // MARK: Callbacks
    
    var onReady: (() -> Void)?
    var onBuffering: ((Bool) -> Void)?
    var onCompletion: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    
    // MARK: Private
    
    private var statusObserver: NSKeyValueObservation?
    private var bufferObserver: NSKeyValueObservation?
    
    private weak var item: AVPlayerItem?
    
    private var isBuffering = false
    
    
    // MARK: Observe
    
    func attach(to item: AVPlayerItem) {
        detach()
        
        self.item = item
        
        observeStatus(item)
        observeBuffering(item)
        observeCompletion(item)
    }
    
    
    // MARK: Cleanup
    
    func detach() {
        statusObserver?.invalidate()
        bufferObserver?.invalidate()
        
        statusObserver = nil
        bufferObserver = nil
        
        if let item {
            NotificationCenter.default.removeObserver(
                self,
                name: .AVPlayerItemDidPlayToEndTime,
                object: item
            )
        }
        
        self.item = nil
        isBuffering = false
    }
}


private extension AVPlayerItemObserver {
    
    func observeStatus(_ item: AVPlayerItem) {
        statusObserver = item.observe(\.status, options: [.new, .initial]) { [weak self] item, _ in
            guard let self else { return }
            
            switch item.status {
            case .readyToPlay:
                dispatch { self.onReady?() }
                
            case .failed:
                if let error = item.error {
                    dispatch { self.onError?(error) }
                }
                
            default:
                break
            }
        }
    }
}

private extension AVPlayerItemObserver {
    
    func observeBuffering(_ item: AVPlayerItem) {
        bufferObserver = item.observe(\.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] item, _ in
            guard let self else { return }
            
            let buffering = !item.isPlaybackLikelyToKeepUp
            
            if buffering != self.isBuffering {
                self.isBuffering = buffering
                dispatch { self.onBuffering?(buffering) }
            }
        }
    }
}

private extension AVPlayerItemObserver {
    
    func observeCompletion(_ item: AVPlayerItem) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: item
        )
    }
    
    @objc
    func didFinish() {
        dispatch { onCompletion?() }
    }
}

private extension AVPlayerItemObserver {
    
    func dispatch(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
}
