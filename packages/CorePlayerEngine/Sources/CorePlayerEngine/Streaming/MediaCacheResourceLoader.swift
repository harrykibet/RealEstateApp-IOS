//
//  MediaCacheResourceLoader.swift
//  CorePlayerEngine
//
//  Created by builder on 9/23/26.
//


//
//  MediaCacheResourceLoader.swift
//  CorePlayerEngine
//

import AVFoundation
import Foundation
import UniformTypeIdentifiers

private actor RequestState {

    var requests:
        [ObjectIdentifier:
         AVAssetResourceLoadingRequest] = [:]

    var tasks:
        [ObjectIdentifier:
         Task<Void, Never>] = [:]

    var metadataTask:
        Task<MediaCacheEntry, Error>?
}

@available(iOS 18.0, macOS 10.15, *)
final class MediaCacheResourceLoader:
    NSObject,
    AVAssetResourceLoaderDelegate {

    // MARK: - Constants

    static let scheme =
        "estatia-cache"

    // MARK: - Dependencies

    private let source:
        MediaSource

    private let cacheKey:
        String

    private let store:
        FileMediaCacheStore

    private let fetcher:
        MediaDataFetching

    private let keyFactory:
        MediaCacheKeyProviding

    private let requestChunkSize:
        Int

    // MARK: - Delegate Queue

    /// AVFoundation invokes resource-loader callbacks synchronously
    /// on this queue.
    ///
    /// We never perform blocking network/disk work directly here.
    private let delegateQueue =
        DispatchQueue(
            label:
                "com.estatia.coreplayerengine.resource-loader",
            qos:
                .userInitiated
        )

    // MARK: - Outstanding Work

    /// AVFoundation requires asynchronously handled requests to remain
    /// strongly referenced until completed.
    private var loadingRequests:
        [ObjectIdentifier:
            AVAssetResourceLoadingRequest] = [:]

    private var loadingTasks:
        [ObjectIdentifier:
            Task<Void, Never>] = [:]

    // MARK: - Metadata

    private var metadataTask:
        Task<MediaCacheEntry, Error>?

    // MARK: - Initialization

    init(
        source: MediaSource,
        configuration: PlayerCacheConfiguration
    ) {
        self.source = source

        self.store =
            configuration.store

        self.fetcher =
            configuration.fetcher

        self.keyFactory =
            configuration.keyFactory

        self.requestChunkSize =
            configuration.requestChunkSize

        self.cacheKey =
            configuration.keyFactory.makeKey(
                mediaId:
                    Self.mediaID(
                        from:
                            source
                    ),
                source:
                    source
            )

        super.init()
    }

    // MARK: - URL

    static func cachedURL(
        for sourceURL: URL
    ) -> URL? {

        var components =
            URLComponents(
                url:
                    sourceURL,
                resolvingAgainstBaseURL:
                    false
            )

        components?.scheme =
            scheme

        return components?.url
    }

    // MARK: - AVAssetResourceLoaderDelegate

    func resourceLoader(
        _ resourceLoader:
            AVAssetResourceLoader,
        shouldWaitForLoadingOfRequestedResource
            loadingRequest:
            AVAssetResourceLoadingRequest
    ) -> Bool {

        // Only handle our custom scheme.
        guard
            loadingRequest.request.url?
                .scheme
                == Self.scheme
        else {
            return false
        }

        let identifier =
            ObjectIdentifier(
                loadingRequest
            )

        loadingRequests[
            identifier
        ] =
            loadingRequest

        let task =
            Task {
                [weak self,
                 weak loadingRequest] in

                guard
                    let self,
                    let loadingRequest
                else {
                    return
                }

                await self.process(
                    loadingRequest
                )
            }

        loadingTasks[
            identifier
        ] =
            task

        return true
    }

    func resourceLoader(
        _ resourceLoader:
            AVAssetResourceLoader,
        didCancel loadingRequest:
            AVAssetResourceLoadingRequest
    ) {

        let identifier =
            ObjectIdentifier(
                loadingRequest
            )

        loadingTasks[
            identifier
        ]?.cancel()

        loadingTasks.removeValue(
            forKey:
                identifier
        )

        loadingRequests.removeValue(
            forKey:
                identifier
        )
    }

    // MARK: - Processing

    private func process(
        _ loadingRequest:
            AVAssetResourceLoadingRequest
    ) async {

        let identifier =
            ObjectIdentifier(
                loadingRequest
            )

        do {

            try Task.checkCancellation()

            if
                loadingRequest
                    .contentInformationRequest
                    != nil
                ||
                loadingRequest
                    .dataRequest?
                    .requestsAllDataToEndOfResource
                    == true
            {
                let metadata =
                    try await metadata()

                try Task.checkCancellation()

                populateContentInformation(
                    loadingRequest:
                        loadingRequest,
                    metadata:
                        metadata
                )
            }

            if let dataRequest =
                loadingRequest.dataRequest {

                try await fulfill(
                    dataRequest:
                        dataRequest,
                    loadingRequest:
                        loadingRequest
                )
            }

            guard !loadingRequest.isCancelled else {
                return
            }

            loadingRequest.finishLoading()

        } catch is CancellationError {

            // AVFoundation already knows the request was cancelled.
            // Do not turn cancellation into a playback error.

        } catch {

            guard !loadingRequest.isCancelled else {
                return
            }

            loadingRequest.finishLoading(
                with:
                    Self.mapError(
                        error
                    )
            )
        }

        loadingTasks.removeValue(
            forKey:
                identifier
        )

        loadingRequests.removeValue(
            forKey:
                identifier
        )
    }

    // MARK: - Metadata

    private func metadata()
        async throws -> MediaCacheEntry {

        if let metadataTask {
            return try await metadataTask.value
        }

        let task =
            Task<MediaCacheEntry, Error> {
                [store,
                 fetcher,
                 source,
                 cacheKey,
                 requestChunkSize] in

                if let existing =
                    try await store.entry(
                        key:
                            cacheKey
                    ),
                   existing.totalLength != nil,
                   existing.contentType != nil {

                    return existing
                }

                let response =
                    try await fetcher.fetch(
                        source:
                            source,
                        offset:
                            0,
                        length:
                            requestChunkSize
                    )

                guard
                    response.statusCode == 200 ||
                    response.statusCode == 206
                else {
                    throw MediaCacheResourceLoaderError
                        .unexpectedHTTPStatus(
                            response.statusCode
                        )
                }

                guard !response.data.isEmpty else {
                    throw MediaCacheResourceLoaderError
                        .emptyResponse
                }

                try await store.writeChunk(
                    key:
                        cacheKey,
                    offset:
                        0,
                    data:
                        response.data,
                    contentType:
                        response.contentType,
                    totalLength:
                        response.totalLength
                )

                guard
                    let metadata =
                        try await store.entry(
                            key:
                                cacheKey
                        )
                else {
                    throw MediaCacheResourceLoaderError
                        .metadataUnavailable
                }

                return metadata
            }

        metadataTask =
            task

        defer {
            metadataTask = nil
        }

        return try await task.value
    }

    private func populateContentInformation(
        loadingRequest:
            AVAssetResourceLoadingRequest,
        metadata:
            MediaCacheEntry
    ) {

        guard
            let information =
                loadingRequest
                    .contentInformationRequest
        else {
            return
        }

        if let contentType =
            metadata.contentType {

            information.contentType =
                Self.contentTypeIdentifier(
                    from:
                        contentType,
                    source:
                        source
                )
        }
        else if let fallback =
            Self.contentTypeIdentifier(
                source:
                    source
            ) {

            information.contentType =
                fallback
        }

        if let totalLength =
            metadata.totalLength {

            information.contentLength =
                totalLength
        }

        information.isByteRangeAccessSupported =
            true
    }

    // MARK: - Data

    private func fulfill(
        dataRequest:
            AVAssetResourceLoadingDataRequest,
        loadingRequest:
            AVAssetResourceLoadingRequest
    ) async throws {

        let requestedOffset =
            dataRequest.currentOffset

        guard requestedOffset >= 0 else {
            throw MediaCacheResourceLoaderError
                .invalidRange
        }

        let totalLength =
            try await resolvedContentLength(
                loadingRequest:
                    loadingRequest
            )

        let requestedLength: Int64

        if dataRequest
            .requestsAllDataToEndOfResource
        {
            guard
                let totalLength
            else {
                throw MediaCacheResourceLoaderError
                    .resourceLengthUnavailable
            }

            guard requestedOffset < totalLength else {
                return
            }

            requestedLength =
                totalLength -
                requestedOffset

        } else {

            requestedLength =
                Int64(
                    dataRequest.requestedLength
                )
        }

        guard requestedLength > 0 else {
            return
        }

        var remaining =
            requestedLength

        var offset =
            requestedOffset

        while remaining > 0 {

            try Task.checkCancellation()

            guard !loadingRequest.isCancelled else {
                throw CancellationError()
            }

            let chunkLength =
                min(
                    remaining,
                    Int64(
                        requestChunkSize
                    )
                )

            if let cached =
                try await store.read(
                    key:
                        cacheKey,
                    offset:
                        offset,
                    length:
                        Int(
                            chunkLength
                        )
                ),
               !cached.isEmpty {

                dataRequest.respond(
                    with:
                        cached
                )

                let consumed =
                    Int64(
                        cached.count
                    )

                offset += consumed
                remaining -= consumed

                continue
            }

            let response =
                try await fetcher.fetch(
                    source:
                        source,
                    offset:
                        offset,
                    length:
                        Int(
                            chunkLength
                        )
                )

            guard
                response.statusCode == 200 ||
                response.statusCode == 206
            else {

                throw MediaCacheResourceLoaderError
                    .unexpectedHTTPStatus(
                        response.statusCode
                    )
            }

            // A byte-range request that is not satisfied by the server
            // must not be interpreted as data starting at our requested
            // offset.
            if offset > 0 &&
                response.statusCode == 200 {

                throw MediaCacheResourceLoaderError
                    .rangeNotSupported
            }

            guard !response.data.isEmpty else {
                break
            }

            let bytes =
                Data(
                    response.data.prefix(
                        Int(
                            chunkLength
                        )
                    )
                )

            try await store.writeChunk(
                key:
                    cacheKey,
                offset:
                    offset,
                data:
                    bytes,
                contentType:
                    response.contentType,
                totalLength:
                    response.totalLength
            )

            dataRequest.respond(
                with:
                    bytes
            )

            let consumed =
                Int64(
                    bytes.count
                )

            offset += consumed
            remaining -= consumed

            // Avoid an infinite loop when an origin returns less data
            // than requested without advertising an end-of-resource.
            if consumed == 0 {
                break
            }

            if consumed <
                chunkLength {

                break
            }
        }
    }

    private func resolvedContentLength(
        loadingRequest:
            AVAssetResourceLoadingRequest
    ) async throws -> Int64? {

        if let contentLength =
            loadingRequest
                .contentInformationRequest?
                .contentLength,
           contentLength > 0 {

            return contentLength
        }

        let metadata =
            try await metadata()

        return metadata.totalLength
    }

    // MARK: - Helpers

    private static func mediaID(
        from source:
            MediaSource
    ) -> String {

        if let id =
            source.metadata?.id,
           !id.isEmpty {

            return id
        }

        return source.url.absoluteString
    }

    private static func contentTypeIdentifier(
        from mimeType:
            String,
        source:
            MediaSource
    ) -> String? {

        if let type =
            UTType(
                mimeType:
                    mimeType
            ) {

            return type.identifier
        }

        return contentTypeIdentifier(
            source:
                source
        )
    }

    private static func contentTypeIdentifier(
        source:
            MediaSource
    ) -> String? {

        guard let extensionName =
                source.url
                    .pathExtension
                    .nilIfEmpty
        else {
            return nil
        }

        return UTType(
            filenameExtension:
                extensionName
        )?.identifier
    }

    private static func mapError(
        _ error:
            Error
    ) -> NSError {

        if let error =
            error as?
                NSError {

            return error
        }

        return error as NSError
    }

    deinit {

        for task in
            loadingTasks.values {

            task.cancel()
        }

        metadataTask?.cancel()
    }
}

private enum MediaCacheResourceLoaderError:
    Error,
    Equatable {

    case invalidRange
    case emptyResponse
    case metadataUnavailable
    case resourceLengthUnavailable
    case rangeNotSupported
    case unexpectedHTTPStatus(Int)
}

private extension String {

    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
