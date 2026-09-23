//
//  MediaCacheWarmerTests.swift
//  CorePlayerEngine
//
//  Created by builder on 9/23/26.
//


import XCTest
@testable import CorePlayerEngine

@available(iOS 18.0, macOS 10.15, *)
final class MediaCacheWarmerTests:
    XCTestCase {

    final class FakeFetcher:
        MediaDataFetching,
        @unchecked Sendable {

        private(set) var offsets:
            [Int64] = []

        private let payload:
            Data

        init(
            payload: Data
        ) {
            self.payload = payload
        }

        func fetch(
            source: MediaSource,
            offset: Int64,
            length: Int
        ) async throws -> MediaDataFetchResponse {

            offsets.append(
                offset
            )

            guard offset <
                Int64(
                    payload.count
                )
            else {
                return MediaDataFetchResponse(
                    statusCode:
                        416,
                    data:
                        Data(),
                    contentType:
                        nil,
                    totalLength:
                        Int64(
                            payload.count
                        )
                )
            }

            let start =
                Int(offset)

            let end =
                min(
                    start + length,
                    payload.count
                )

            return MediaDataFetchResponse(
                statusCode:
                    206,
                data:
                    payload.subdata(
                        in:
                            start..<end
                    ),
                contentType:
                    "video/mp4",
                totalLength:
                    Int64(
                        payload.count
                    )
            )
        }
    }

    private func makeStore()
        throws
        -> (
            FileMediaCacheStore,
            URL
        ) {

        let directory =
            FileManager.default
                .temporaryDirectory
                .appendingPathComponent(
                    UUID().uuidString,
                    isDirectory: true
                )

        return (
            FileMediaCacheStore(
                rootDirectory:
                    directory
            ),
            directory
        )
    }

    private func makeSource()
        -> MediaSource {

        MediaSource(
            url:
                URL(
                    string:
                        "https://example.com/video.mp4"
                )!,
            type:
                .progressive
        )
    }

    func testWarmerStoresBoundedPrefix()
        async throws {

        let (
            store,
            directory
        ) =
            try makeStore()

        defer {
            try? FileManager.default
                .removeItem(
                    at:
                        directory
                )
        }

        let payload =
            Data(
                "abcdefghijkl".utf8
            )

        let fetcher =
            FakeFetcher(
                payload:
                    payload
            )

        let sizing =
            MediaCacheSizingPolicy(
                visibleBytes:
                    10,
                nextBytes:
                    8,
                previousBytes:
                    4,
                speculativeBytes:
                    4,
                chunkBytes:
                    4,
                maximumCacheBytes:
                    1_000
            )

        let warmer =
            MediaCacheWarmer(
                store:
                    store,
                fetcher:
                    fetcher,
                sizingPolicy:
                    sizing
            )

        let keyFactory =
            DefaultMediaCacheKeyFactory()

        let key =
            keyFactory.makeKey(
                mediaId:
                    "video",
                source:
                    makeSource()
            )

        let result =
            await warmer.warm(
                MediaCacheWarmRequest(
                    mediaId:
                        "video",
                    source:
                        makeSource(),
                    cacheKey:
                        key,
                    priority:
                        .visible
                )
            )

        XCTAssertEqual(
            result,
            .warmed(
                bytes:
                    10,
                chunks:
                    3
            )
        )

        let cached =
            try await store.read(
                key:
                    key,
                offset:
                    0,
                length:
                    10
            )

        XCTAssertEqual(
            cached,
            Data(
                "abcdefghij".utf8
            )
        )

        XCTAssertEqual(
            fetcher.offsets,
            [0, 4, 8]
        )
    }

    func testSecondWarmReusesCachedChunks()
        async throws {

        let (
            store,
            directory
        ) =
            try makeStore()

        defer {
            try? FileManager.default
                .removeItem(
                    at:
                        directory
                )
        }

        let payload =
            Data(
                "abcdefghijkl".utf8
            )

        let fetcher =
            FakeFetcher(
                payload:
                    payload
            )

        let sizing =
            MediaCacheSizingPolicy(
                visibleBytes:
                    8,
                nextBytes:
                    4,
                previousBytes:
                    4,
                speculativeBytes:
                    4,
                chunkBytes:
                    4,
                maximumCacheBytes:
                    1_000
            )

        let warmer =
            MediaCacheWarmer(
                store:
                    store,
                fetcher:
                    fetcher,
                sizingPolicy:
                    sizing
            )

        let source =
            makeSource()

        let key =
            DefaultMediaCacheKeyFactory()
                .makeKey(
                    mediaId:
                        "video",
                    source:
                        source
                )

        let request =
            MediaCacheWarmRequest(
                mediaId:
                    "video",
                source:
                    source,
                cacheKey:
                    key,
                priority:
                    .visible
            )

        _ = await warmer.warm(
            request
        )

        let firstFetchCount =
            fetcher.offsets.count

        _ = await warmer.warm(
            request
        )

        XCTAssertEqual(
            fetcher.offsets.count,
            firstFetchCount
        )
    }

    func testHLSIsNotPretendedToBeProgressiveCache()
        async throws {

        let (
            store,
            directory
        ) =
            try makeStore()

        defer {
            try? FileManager.default
                .removeItem(
                    at:
                        directory
                )
        }

        let fetcher =
            FakeFetcher(
                payload:
                    Data(
                        "playlist".utf8
                    )
            )

        let warmer =
            MediaCacheWarmer(
                store:
                    store,
                fetcher:
                    fetcher
            )

        let source =
            MediaSource(
                url:
                    URL(
                        string:
                            "https://example.com/video.m3u8"
                    )!,
                type:
                    .hls
            )

        let key =
            DefaultMediaCacheKeyFactory()
                .makeKey(
                    mediaId:
                        "hls",
                    source:
                        source
                )

        let result =
            await warmer.warm(
                MediaCacheWarmRequest(
                    mediaId:
                        "hls",
                    source:
                        source,
                    cacheKey:
                        key,
                    priority:
                        .visible
                )
            )

        XCTAssertEqual(
            result,
            .skippedUnsupportedMediaType
        )

        XCTAssertTrue(
            fetcher.offsets.isEmpty
        )
    }
}