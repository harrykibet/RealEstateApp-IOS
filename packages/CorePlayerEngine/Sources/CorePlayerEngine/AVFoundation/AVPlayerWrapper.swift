//
//  AVPlayerWrapper.swift
//  CorePlayerEngine
//
//  Created by builder on 9/24/26.
//


//
//  AVPlayerWrapper.swift
//  CorePlayerEngine
//

import AVFoundation
import Foundation

@available(iOS 18.0, macOS 10.15, *)
final class AVPlayerWrapper:
    @unchecked Sendable {

    // MARK: - Callbacks

    var onReady:
        (@MainActor @Sendable () -> Void)?

    var onBuffering:
        (@MainActor @Sendable (Bool) -> Void)?

    var onCompletion:
        (@MainActor @Sendable () -> Void)?

    var onError:
        (@MainActor @Sendable (Error) -> Void)?

    var onProgress:
        (@MainActor @Sendable (PlaybackProgress) -> Void)?

    // MARK: - AVFoundation

    private var player:
        AVPlayer?

    private var playerItem:
        AVPlayerItem?

    private var asset:
        AVURLAsset?

    // MARK: - Resource Loader

    private var resourceLoader:
        MediaCacheResourceLoader?

    private let resourceLoaderQueue =
        DispatchQueue(
            label:
                "com.estatia.coreplayerengine.resource-loader",
            qos:
                .userInitiated
        )

    // MARK: - Observers

    private let itemObserver =
        AVPlayerItemObserver()

    private let timeObserver:
        AVPlayerTimeObserver

    // MARK: - Player Queue

    private let queue =
        DispatchQueue(
            label:
                "com.estatia.coreplayerengine.player-wrapper",
            qos:
                .userInitiated
        )

    // MARK: - Configuration

    private let progressInterval:
        TimeInterval

    private let cacheConfiguration:
        PlayerCacheConfiguration?

    // MARK: - Initialization

    init(
        progressInterval:
            TimeInterval,

        cacheConfiguration:
            PlayerCacheConfiguration? = nil
    ) {
        self.progressInterval =
            progressInterval

        self.cacheConfiguration =
            cacheConfiguration

        self.timeObserver =
            AVPlayerTimeObserver(
                interval:
                    progressInterval,
                queue:
                    queue
            )
    }

    deinit {

        queue.sync {
            cleanup()
        }
    }

    // MARK: - Load

    nonisolated(nonsending)
    func load(
        _ source:
            MediaSource
    ) async throws {

        try await withCheckedThrowingContinuation {
            (
                continuation:
                    CheckedContinuation<
                        Void,
                        Error
                    >
            ) in

            queue.async { [weak self] in

                guard let self else {

                    continuation.resume(
                        throwing:
                            PlayerError.unknown
                    )

                    return
                }

                do {

                    try self.loadSynchronously(
                        source:
                            source
                    )

                    continuation.resume()

                } catch {

                    continuation.resume(
                        throwing:
                            error
                    )
                }
            }
        }
    }

    private func loadSynchronously(
        source:
            MediaSource
    ) throws {

        cleanup()

        let useCache =
            cacheConfiguration != nil &&
            Self.isProgressivelyCacheable(
                source
            )

        if useCache,
           let cacheConfiguration {

            try loadCached(
                source:
                    source,
                configuration:
                    cacheConfiguration
            )

        } else {

            loadDirect(
                source:
                    source
            )
        }
    }

    // MARK: - Cached Load

    private func loadCached(
        source:
            MediaSource,
        configuration:
            PlayerCacheConfiguration
    ) throws {

        guard let cachedURL =
                MediaCacheResourceLoader.cachedURL(
                    for:
                        source.url
                )
        else {

            throw PlayerError.invalidSource
        }

        let cacheKey =
            configuration.keyFactory.makeKey(
                mediaId:
                    Self.mediaID(
                        from:
                            source
                    ),
                source:
                    source
            )

        let loader =
            MediaCacheResourceLoader(
                source:
                    source,
                configuration:
                    configuration
            )

        let urlAsset =
            AVURLAsset(
                url:
                    cachedURL,
                options:
                    nil
            )

        urlAsset.resourceLoader.setDelegate(
            loader,
            queue:
                resourceLoaderQueue
        )

        let item =
            AVPlayerItem(
                asset:
                    urlAsset
            )

        install(
            asset:
                urlAsset,
            item:
                item,
            resourceLoader:
                loader
        )

        _ = cacheKey
    }

    // MARK: - Direct Load

    private func loadDirect(
        source:
            MediaSource
    ) {

        var options:
            [String: Any] = [:]

        if let headers =
            source.headers {

            options[
                "AVURLAssetHTTPHeaderFieldsKey"
            ] =
                headers
        }

        let urlAsset =
            AVURLAsset(
                url:
                    source.url,
                options:
                    options
            )

        let item =
            AVPlayerItem(
                asset:
                    urlAsset
            )

        install(
            asset:
                urlAsset,
            item:
                item,
            resourceLoader:
                nil
        )
    }

    // MARK: - Install

    private func install(
        asset:
            AVURLAsset,
        item:
            AVPlayerItem,
        resourceLoader:
            MediaCacheResourceLoader?
    ) {

        self.asset =
            asset

        self.playerItem =
            item

        self.player =
            AVPlayer(
                playerItem:
                    item
            )

        self.resourceLoader =
            resourceLoader

        itemObserver.attach(
            to:
                item
        )

        timeObserver.attach(
            player:
                player!,
            item:
                item
        )

        itemObserver.onReady =
            { [weak self] in

                self?.dispatch {
                    self?.onReady?()
                }
            }

        itemObserver.onBuffering =
            { [weak self] buffering in

                self?.dispatch {
                    self?.onBuffering?(
                        buffering
                    )
                }
            }

        itemObserver.onCompletion =
            { [weak self] in

                self?.dispatch {
                    self?.onCompletion?()
                }
            }

        itemObserver.onError =
            { [weak self] error in

                self?.dispatch {
                    self?.onError?(
                        error
                    )
                }
            }

        timeObserver.onProgress =
            { [weak self] progress in

                self?.dispatch {
                    self?.onProgress?(
                        progress
                    )
                }
            }
    }

    // MARK: - Playback

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

            self?.player?.seek(
                to:
                    .zero
            )
        }
    }

    // MARK: - Seek

    nonisolated(nonsending)
    func seek(
        to seconds:
            TimeInterval
    ) async throws {

        try await withCheckedThrowingContinuation {
            (
                continuation:
                    CheckedContinuation<
                        Void,
                        Error
                    >
            ) in

            queue.async { [weak self] in

                guard
                    let self,
                    let player =
                        self.player
                else {

                    continuation.resume(
                        throwing:
                            PlayerError.seekFailed
                    )

                    return
                }

                let time =
                    CMTime(
                        seconds:
                            seconds,
                        preferredTimescale:
                            600
                    )

                player.seek(
                    to:
                        time,
                    toleranceBefore:
                        .zero,
                    toleranceAfter:
                        .zero
                ) { finished in

                    if finished {

                        continuation.resume()

                    } else {

                        continuation.resume(
                            throwing:
                                PlayerError.seekFailed
                        )
                    }
                }
            }
        }
    }

    // MARK: - Release

    func release() {

        queue.sync {
            cleanup()
        }
    }

    // MARK: - Cleanup

    private func cleanup() {

        resourceLoader =
            nil

        itemObserver.detach()

        timeObserver.detach()

        player?.pause()

        player?.replaceCurrentItem(
            with:
                nil
        )

        player =
            nil

        playerItem =
            nil

        asset =
            nil
    }

    // MARK: - Dispatch

    private func dispatch(
        _ block:
            @MainActor
            @Sendable
            @escaping () -> Void
    ) {

        Task { @MainActor in
            block()
        }
    }

    // MARK: - Cacheability

    private static func
        isProgressivelyCacheable(
            _ source:
                MediaSource
        ) -> Bool {

        switch source.type {

        case .progressive:
            return true

        case .hls,
             .dash,
             .file:
            return false

        case .auto:

            let extensionName =
                source.url
                    .pathExtension
                    .lowercased()

            return extensionName != "m3u8" &&
                   extensionName != "mpd"
        }
    }

    // MARK: - Media Identity

    private static func mediaID(
        from source:
            MediaSource
    ) -> String {

        if let metadataID =
            source.metadata?.id,
           !metadataID.isEmpty {

            return metadataID
        }

        return source.url.absoluteString
    }
}