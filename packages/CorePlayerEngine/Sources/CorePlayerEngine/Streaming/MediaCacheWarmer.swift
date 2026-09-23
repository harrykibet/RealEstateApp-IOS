//
//  MediaCacheWarmer.swift
//  CorePlayerEngine
//
//  Created by builder on 9/18/26.
//

//
//  MediaCacheWarmer.swift
//  CorePlayerEngine
//

import Foundation

public struct MediaDataFetchResponse:
    Sendable {

    public let statusCode: Int
    public let data: Data
    public let contentType: String?
    public let totalLength: Int64?

    public init(
        statusCode: Int,
        data: Data,
        contentType: String?,
        totalLength: Int64?
    ) {
        self.statusCode = statusCode
        self.data = data
        self.contentType = contentType
        self.totalLength = totalLength
    }
}

public protocol MediaDataFetching:
    Sendable {

    func fetch(
        source: MediaSource,
        offset: Int64,
        length: Int
    ) async throws -> MediaDataFetchResponse
}

public enum MediaDataFetchError:
    Error,
    Equatable {

    case unacceptableStatus(Int)
}

public final class URLSessionMediaDataFetcher:
    MediaDataFetching,
    @unchecked Sendable {

    private let session: URLSession

    public init(
        session: URLSession =
            URLSession(
                configuration: .ephemeral
            )
    ) {
        self.session = session
    }

    public func fetch(
        source: MediaSource,
        offset: Int64,
        length: Int
    ) async throws -> MediaDataFetchResponse {

        guard length > 0,
              offset >= 0
        else {
            throw URLError(
                .badURL
            )
        }

        var request =
            URLRequest(
                url: source.url
            )

        request.httpMethod =
            "GET"

        request.setValue(
            "bytes=\(offset)-\(offset + Int64(length) - 1)",
            forHTTPHeaderField: "Range"
        )

        request.timeoutInterval =
            15

        if let headers =
            source.headers {

            for (key, value) in headers {

                request.setValue(
                    value,
                    forHTTPHeaderField: key
                )
            }
        }

        let (
            data,
            response
        ) = try await session.data(
            for: request
        )

        guard let http =
                response as? HTTPURLResponse
        else {
            throw MediaDataFetchError
                .unacceptableStatus(
                    -1
                )
        }

        return MediaDataFetchResponse(
            statusCode:
                http.statusCode,
            data:
                data,
            contentType:
                http.mimeType,
            totalLength:
                Self.totalLength(
                    from: http
                )
        )
    }

    private static func totalLength(
        from response: HTTPURLResponse
    ) -> Int64? {

        guard let header =
                response.value(
                    forHTTPHeaderField:
                        "Content-Range"
                )
        else {

            return nil
        }

        // Example:
        // bytes 0-524287/9834212
        guard let slash =
                header.lastIndex(
                    of: "/"
                )
        else {
            return nil
        }

        let totalPart =
            header[
                header.index(
                    after: slash
                )...
            ]

        guard totalPart != "*" else {
            return nil
        }

        return Int64(
            totalPart
        )
    }
}

public struct MediaCacheWarmRequest:
    Sendable {

    public let mediaId: String
    public let source: MediaSource
    public let cacheKey: String
    public let priority: WarmPriority

    public init(
        mediaId: String,
        source: MediaSource,
        cacheKey: String,
        priority: WarmPriority
    ) {
        self.mediaId = mediaId
        self.source = source
        self.cacheKey = cacheKey
        self.priority = priority
    }
}

public enum MediaCacheWarmResult:
    Sendable,
    Equatable {

    case skippedUnsupportedMediaType
    case alreadyCached(bytes: Int64)
    case warmed(bytes: Int64, chunks: Int)
}

@available(iOS 18.0, macOS 10.15, *)
public final class MediaCacheWarmer:
    @unchecked Sendable {

    private let store:
        FileMediaCacheStore

    private let fetcher:
        MediaDataFetching

    private let sizingPolicy:
        MediaCacheSizingPolicy

    private let environmentProvider:
        @Sendable () async ->
        MediaCacheWarmEnvironment

    private let metrics:
        MetricsCollector?

    public init(
        store: FileMediaCacheStore,
        fetcher:
            MediaDataFetching =
            URLSessionMediaDataFetcher(),
        sizingPolicy:
            MediaCacheSizingPolicy =
            MediaCacheSizingPolicy(),
        environmentProvider:
            @escaping @Sendable () async ->
            MediaCacheWarmEnvironment = {
                MediaCacheWarmEnvironment()
            },
        metrics:
            MetricsCollector? = nil
    ) {
        self.store = store
        self.fetcher = fetcher
        self.sizingPolicy = sizingPolicy
        self.environmentProvider =
            environmentProvider
        self.metrics = metrics
    }

    public func warm(
        _ request:
            MediaCacheWarmRequest
    ) async -> MediaCacheWarmResult {

        guard
            Self.isProgressivelyCacheable(
                request.source
            )
        else {

            return .skippedUnsupportedMediaType
        }

        let environment =
            await environmentProvider()

        let budget =
            sizingPolicy.budget(
                for: request.priority,
                environment: environment
            )

        let chunkSize =
            sizingPolicy.chunkBytes

        var offset: Int64 = 0

        var warmedBytes: Int64 = 0

        var warmedChunks = 0

        while offset < budget {

            guard !Task.isCancelled else {
                return .warmed(
                    bytes: warmedBytes,
                    chunks: warmedChunks
                )
            }

            let requestedLength =
                min(
                    chunkSize,
                    Int(
                        budget - offset
                    )
                )

            if let cached =
                try? await store.read(
                    key: request.cacheKey,
                    offset: offset,
                    length: requestedLength
                ),
               cached.count == requestedLength {

                offset +=
                    Int64(
                        requestedLength
                    )

                continue
            }

            do {

                let response =
                    try await fetcher.fetch(
                        source: request.source,
                        offset: offset,
                        length: requestedLength
                    )

                if response.statusCode == 416 {
                    break
                }

                guard response.statusCode == 200 ||
                      response.statusCode == 206
                else {

                    return .warmed(
                        bytes: warmedBytes,
                        chunks: warmedChunks
                    )
                }

                // If a server ignores Range and returns the entire resource,
                // accepting that response for offset > 0 would corrupt the
                // cache because the returned bytes begin at zero.
                if offset > 0 &&
                    response.statusCode == 200 {

                    return .warmed(
                        bytes: warmedBytes,
                        chunks: warmedChunks
                    )
                }

                let data =
                    response.data.prefix(
                        requestedLength
                    )

                guard !data.isEmpty else {
                    break
                }

                let chunk =
                    Data(data)

                try await store.writeChunk(
                    key:
                        request.cacheKey,
                    offset:
                        offset,
                    data:
                        chunk,
                    contentType:
                        response.contentType,
                    totalLength:
                        response.totalLength
                )

                offset +=
                    Int64(
                        chunk.count
                    )

                warmedBytes +=
                    Int64(
                        chunk.count
                    )

                warmedChunks += 1

                if let totalLength =
                    response.totalLength,
                   offset >= totalLength {

                    break
                }

                if chunk.count <
                    requestedLength {

                    break
                }

            } catch {

                metrics?.onPrefetchFailed(
                    mediaId:
                        request.mediaId,
                    error:
                        error
                )

                break
            }
        }

        try? await store.trim(
            to:
                sizingPolicy.maximumCacheBytes
        )

        metrics?.onPrefetch(
            mediaId:
                request.mediaId,
            bytes:
                Int(
                    min(
                        warmedBytes,
                        Int64(
                            Int.max
                        )
                    )
                ),
            time:
                0
        )

        return .warmed(
            bytes:
                warmedBytes,
            chunks:
                warmedChunks
        )
    }

    private static func
        isProgressivelyCacheable(
            _ source: MediaSource
        ) -> Bool {

        switch source.type {

        case .progressive:
            return true

        case .file:
            return false

        case .hls:
            return false

        case .dash:
            return false

        case .auto:

            let ext =
                source.url
                    .pathExtension
                    .lowercased()

            return ext != "m3u8" &&
                   ext != "mpd"
        }
    }
}
