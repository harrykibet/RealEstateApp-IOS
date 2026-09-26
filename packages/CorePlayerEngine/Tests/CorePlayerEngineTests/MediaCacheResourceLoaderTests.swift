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