//
//  AVPlayerItemObserver.swift
//  CorePlayerEngine
//
//  Responsibility:
//  - Observes AVPlayerItem KVO + notifications
//  - Emits high-level PlayerEvent signals
//  - Contains NO business logic or state ownership
//
//  Design:
//  - Stateless (except minimal lifecycle tracking)
//  - Does not dispatch threads (caller decides)
//  - Safe attach/detach lifecycle
//

import Foundation
import AVFoundation

final class AVPlayerItemObserver {

    // MARK: - Event Sink

    /// Single event emission point → eliminates callback fragmentation
    var emit: ((PlayerEvent) -> Void)?

    // MARK: - Private

    private var statusObserver: NSKeyValueObservation?
    private var bufferObserver: NSKeyValueObservation?

    private var endObserver: NSObjectProtocol?
    private var failureObserver: NSObjectProtocol?

    private weak var item: AVPlayerItem?

    // MARK: - Public API

    func attach(to item: AVPlayerItem) {
        detach()

        self.item = item

        observeStatus(item)
        observeBuffering(item)
        observeCompletion(item)
        observeFailure(item)
    }

    func detach() {
        statusObserver?.invalidate()
        bufferObserver?.invalidate()

        statusObserver = nil
        bufferObserver = nil

        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
        }

        if let failureObserver {
            NotificationCenter.default.removeObserver(failureObserver)
        }

        endObserver = nil
        failureObserver = nil

        item = nil
    }
}

// MARK: - Observations

private extension AVPlayerItemObserver {

    func observeStatus(_ item: AVPlayerItem) {
        statusObserver = item.observe(\.status, options: [.new, .initial]) { [weak self] item, _ in
            guard let self else { return }

            switch item.status {
            case .readyToPlay:
                emit?(.ready)

            case .failed:
                if let error = item.error {
                emit?(.failed(PlayerError.from(error)))
                } else {
                    emit?(.failed(.unknown))
                }

            case .unknown:
                break
            @unknown default:
                break
            }
        }
    }

    func observeBuffering(_ item: AVPlayerItem) {
        bufferObserver = item.observe(\.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] item, _ in
            guard let self else { return }

            let isBuffering = !item.isPlaybackLikelyToKeepUp

            emit?(isBuffering ? .bufferingStarted : .bufferingEnded)
        }
    }

    func observeCompletion(_ item: AVPlayerItem) {
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: nil
        ) { [weak self] _ in
            self?.emit?(.playbackCompleted)
        }
    }

    func observeFailure(_ item: AVPlayerItem) {
        failureObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: item,
            queue: nil
        ) { [weak self] notification in
            let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error
            self?.emit?(.failed(error.map { PlayerError.from($0) } ?? .unknown))
        }
    }
}
