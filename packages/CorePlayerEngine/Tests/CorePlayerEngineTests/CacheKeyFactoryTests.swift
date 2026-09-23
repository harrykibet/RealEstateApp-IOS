//
//  CacheKeyFactoryTests.swift
//  CorePlayerEngine
//
//  Created by builder on 9/23/26.
//


import XCTest
@testable import CorePlayerEngine

final class CacheKeyFactoryTests: XCTestCase {

    private let factory =
        DefaultMediaCacheKeyFactory()

    func testSameSourceProducesStableKey() {

        let source =
            MediaSource(
                url:
                    URL(
                        string:
                            "https://example.com/video.mp4"
                    )!
            )

        let first =
            factory.makeKey(
                mediaId:
                    "video-1",
                source:
                    source
            )

        let second =
            factory.makeKey(
                mediaId:
                    "video-1",
                source:
                    source
            )

        XCTAssertEqual(
            first,
            second
        )
    }

    func testDifferentMediaIdsProduceDifferentKeys() {

        let source =
            MediaSource(
                url:
                    URL(
                        string:
                            "https://example.com/video.mp4"
                    )!
            )

        let first =
            factory.makeKey(
                mediaId:
                    "video-1",
                source:
                    source
            )

        let second =
            factory.makeKey(
                mediaId:
                    "video-2",
                source:
                    source
            )

        XCTAssertNotEqual(
            first,
            second
        )
    }

    func testDifferentUrlsProduceDifferentKeys() {

        let firstSource =
            MediaSource(
                url:
                    URL(
                        string:
                            "https://example.com/a.mp4"
                    )!
            )

        let secondSource =
            MediaSource(
                url:
                    URL(
                        string:
                            "https://example.com/b.mp4"
                    )!
            )

        XCTAssertNotEqual(
            factory.makeKey(
                mediaId:
                    "video",
                source:
                    firstSource
            ),
            factory.makeKey(
                mediaId:
                    "video",
                source:
                    secondSource
            )
        )
    }

    func testDifferentHeadersProduceDifferentKeys() {

        let firstSource =
            MediaSource(
                url:
                    URL(
                        string:
                            "https://example.com/video.mp4"
                    )!,
                headers: [
                    "Authorization":
                        "Bearer-a"
                ]
            )

        let secondSource =
            MediaSource(
                url:
                    URL(
                        string:
                            "https://example.com/video.mp4"
                    )!,
                headers: [
                    "Authorization":
                        "Bearer-b"
                ]
            )

        XCTAssertNotEqual(
            factory.makeKey(
                mediaId:
                    "video",
                source:
                    firstSource
            ),
            factory.makeKey(
                mediaId:
                    "video",
                source:
                    secondSource
            )
        )
    }

    func testHeaderOrderingDoesNotChangeKey() {

        let firstSource =
            MediaSource(
                url:
                    URL(
                        string:
                            "https://example.com/video.mp4"
                    )!,
                headers: [
                    "B": "2",
                    "A": "1"
                ]
            )

        let secondSource =
            MediaSource(
                url:
                    URL(
                        string:
                            "https://example.com/video.mp4"
                    )!,
                headers: [
                    "A": "1",
                    "B": "2"
                ]
            )

        XCTAssertEqual(
            factory.makeKey(
                mediaId:
                    "video",
                source:
                    firstSource
            ),
            factory.makeKey(
                mediaId:
                    "video",
                source:
                    secondSource
            )
        )
    }
}