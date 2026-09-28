//
//  MediaCacheResourceLoaderTests.swift
//  CorePlayerEngine
//
//  Created by builder on 9/26/26.
//


import XCTest
import AVFoundation
@testable import CorePlayerEngine

@available(iOS 18.0, macOS 10.15, *)
final class MediaCacheResourceLoaderTests:
    XCTestCase {


    private final class RecordingKeyFactory:
        MediaCacheKeyProviding,
        @unchecked Sendable {

        private(set) var receivedMediaId: String?

        func makeKey(
            mediaId: String,
            source: MediaSource
        ) -> String {
            receivedMediaId = mediaId
            return "test-key"
        }
    }

    func testCachedSchemeIsCreated() {

        let original =
            URL(
                string:
                    "https://example.com/video.mp4"
            )!

        let cached =
            MediaCacheResourceLoader
                .cachedURL(
                    for:
                        original
                )

        XCTAssertEqual(
            cached?.scheme,
            "estatia-cache"
        )

        XCTAssertEqual(
            cached?.host,
            original.host
        )

        XCTAssertEqual(
            cached?.path,
            original.path
        )

        XCTAssertEqual(
            cached?.query,
            original.query
        )
    }

    func testLogicalMediaIdIsUsedForCacheIdentity() {

        let directory =
            FileManager.default
                .temporaryDirectory
                .appendingPathComponent(
                    UUID().uuidString,
                    isDirectory: true
                )

        defer {
            try? FileManager.default
                .removeItem(
                    at:
                        directory
                )
        }

        let store =
            FileMediaCacheStore(
                rootDirectory:
                    directory
            )

        let keyFactory =
            RecordingKeyFactory()

        let configuration =
            PlayerCacheConfiguration(
                store:
                    store,
                keyFactory:
                    keyFactory
            )

        _ = MediaCacheResourceLoader(
            mediaId:
                "property-123",
            source:
                MediaSource(
                    url:
                        URL(
                            string:
                                "https://example.com/video.mp4"
                        )!
                ),
            configuration:
                configuration
        )

        XCTAssertEqual(
            keyFactory.receivedMediaId,
            "property-123"
        )
    }

    func testOriginalURLIsNotMutated() {

        let original =
            URL(
                string:
                    "https://example.com/path/video.mp4?token=abc"
            )!

        _ = MediaCacheResourceLoader
            .cachedURL(
                for:
                    original
            )

        XCTAssertEqual(
            original.scheme,
            "https"
        )
    }
}