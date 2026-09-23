//
//  MediaCacheStoreTests.swift
//  CorePlayerEngine
//
//  Created by builder on 9/23/26.
//


import XCTest
@testable import CorePlayerEngine

@available(iOS 18.0, macOS 10.15, *)
final class MediaCacheStoreTests:
    XCTestCase {

    private func makeStore()
        throws
        -> (
            store: FileMediaCacheStore,
            directory: URL
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

    func testWriteAndReadSingleChunk()
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

        let data =
            Data(
                "hello".utf8
            )

        try await store.writeChunk(
            key:
                "video-1",
            offset:
                0,
            data:
                data
        )

        let result =
            try await store.read(
                key:
                    "video-1",
                offset:
                    0,
                length:
                    5
            )

        XCTAssertEqual(
            result,
            data
        )
    }

    func testReadsAcrossMultipleChunks()
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

        try await store.writeChunk(
            key:
                "video-1",
            offset:
                0,
            data:
                Data("hello ".utf8)
        )

        try await store.writeChunk(
            key:
                "video-1",
            offset:
                6,
            data:
                Data("world".utf8)
        )

        let result =
            try await store.read(
                key:
                    "video-1",
                offset:
                    0,
                length:
                    11
            )

        XCTAssertEqual(
            result,
            Data(
                "hello world".utf8
            )
        )
    }

    func testMissingRangeReturnsNil()
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

        try await store.writeChunk(
            key:
                "video-1",
            offset:
                0,
            data:
                Data(
                    "hello".utf8
                )
        )

        let result =
            try await store.read(
                key:
                    "video-1",
                offset:
                    5,
                length:
                    5
            )

        XCTAssertNil(
            result
        )
    }

    func testTrimRemovesCacheUntilUnderLimit()
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

        try await store.writeChunk(
            key:
                "video-1",
            offset:
                0,
            data:
                Data(
                    repeating:
                        1,
                    count:
                        100
                )
        )

        try await store.writeChunk(
            key:
                "video-2",
            offset:
                0,
            data:
                Data(
                    repeating:
                        2,
                    count:
                        100
                )
        )

        try await store.trim(
            to:
                100
        )

        let statistics =
            try await store.statistics()

        XCTAssertLessThanOrEqual(
            statistics.totalBytes,
            100
        )
    }
}