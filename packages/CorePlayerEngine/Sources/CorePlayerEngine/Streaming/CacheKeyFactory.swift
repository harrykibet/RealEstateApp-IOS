//
//  CacheKeyFactory.swift
//  CorePlayerEngine
//

import CryptoKit
import Foundation

public protocol MediaCacheKeyProviding: Sendable {

    func makeKey(
        mediaId: String,
        source: MediaSource
    ) -> String
}

public struct DefaultMediaCacheKeyFactory:
    MediaCacheKeyProviding,
    Sendable {

    public init() {}

    public func makeKey(
        mediaId: String,
        source: MediaSource
    ) -> String {

        var components: [String] = [
            "media-v1",
            mediaId,
            source.url.absoluteString,
            String(describing: source.type)
        ]

        if let headers = source.headers {
            let canonicalHeaders = headers
                .map {
                    (
                        key: $0.key.lowercased(),
                        value: $0.value
                    )
                }
                .sorted {
                    if $0.key == $1.key {
                        return $0.value < $1.value
                    }

                    return $0.key < $1.key
                }

                .map {
                    "\($0.key)=\($0.value)"
                }
                .joined(separator: "&")

            components.append(
                canonicalHeaders
            )
        }

        let canonical =
            components.joined(
                separator: "\n"
            )

        let digest = SHA256.hash(
            data: Data(
                canonical.utf8
            )
        )

        return digest
            .map {
                String(
                    format: "%02x",
                    $0
                )
            }
            .joined()
    }
}
