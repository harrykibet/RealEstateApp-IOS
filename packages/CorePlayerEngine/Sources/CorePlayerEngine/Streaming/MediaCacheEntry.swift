//
//  MediaCacheEntry.swift
//  CorePlayerEngine
//
//  Created by builder on 9/23/26.
//


//
//  MediaCacheStore.swift
//  CorePlayerEngine
//

import Foundation
import CryptoKit

public struct MediaCacheEntry:
    Codable,
    Sendable,
    Equatable {

    public let key: String

    public var contentType: String?

    public var totalLength: Int64?

    public var cachedByteCount: Int64

    public var chunks: [Int64: Int]

    public var createdAt: Date

    public var lastAccessedAt: Date

    public init(
        key: String,
        contentType: String? = nil,
        totalLength: Int64? = nil,
        cachedByteCount: Int64 = 0,
        chunks: [Int64: Int] = [:],
        createdAt: Date = Date(),
        lastAccessedAt: Date = Date()
    ) {
        self.key = key
        self.contentType = contentType
        self.totalLength = totalLength
        self.cachedByteCount = cachedByteCount
        self.chunks = chunks
        self.createdAt = createdAt
        self.lastAccessedAt = lastAccessedAt
    }
}

public struct MediaCacheStatistics:
    Sendable,
    Equatable {

    public let entryCount: Int
    public let totalBytes: Int64

    public init(
        entryCount: Int,
        totalBytes: Int64
    ) {
        self.entryCount = entryCount
        self.totalBytes = totalBytes
    }
}

public enum MediaCacheStoreError:
    Error,
    Equatable {

    case invalidRange
    case invalidKey
    case corruptedEntry
}

/// Persistent byte-range media cache.
///
/// The store is deliberately unaware of AVFoundation. It only understands
/// logical media keys and byte ranges.
///
/// This separation lets the same cache later serve:
/// - AVAssetResourceLoader
/// - offline playback
/// - diagnostics
/// - cache warming
@available(iOS 18.0, macOS 10.15, *)
public actor FileMediaCacheStore {

    // MARK: - Dependencies

    private let rootDirectory:
        URL

    private let fileManager:
        FileManager

    // MARK: - Init

    public init(
        rootDirectory: URL,
        fileManager: FileManager = .default
    ) {
        self.rootDirectory = rootDirectory
        self.fileManager = fileManager
    }

    // MARK: - Read

    public func read(
        key: String,
        offset: Int64,
        length: Int
    ) throws -> Data? {

        guard offset >= 0,
              length > 0
        else {
            throw MediaCacheStoreError.invalidRange
        }

        let metadata =
            try loadEntry(
                key: key
            )

        guard let metadata else {
            return nil
        }

        let requestedEnd =
            offset + Int64(length)

        guard requestedEnd >= offset else {
            throw MediaCacheStoreError.invalidRange
        }

        var cursor = offset

        var result =
            Data()

        while cursor < requestedEnd {

            guard let chunkStart =
                    metadata.chunks.keys
                        .filter {
                            $0 <= cursor
                        }
                        .max()
            else {
                return nil
            }

            guard let chunkLength =
                    metadata.chunks[chunkStart]
            else {
                return nil
            }

            let chunkEnd =
                chunkStart +
                Int64(chunkLength)

            guard cursor < chunkEnd else {
                return nil
            }

            let chunkURL =
                chunkURL(
                    key: key,
                    offset: chunkStart
                )

            guard fileManager.fileExists(
                atPath: chunkURL.path
            ) else {
                return nil
            }

            let data =
                try Data(
                    contentsOf: chunkURL
                )

            guard data.count == chunkLength else {
                throw MediaCacheStoreError.corruptedEntry
            }

            let readStart =
                Int(
                    cursor -
                    chunkStart
                )

            let readEnd =
                min(
                    data.count,
                    readStart +
                    Int(
                        requestedEnd -
                        cursor
                    )
                )

            guard readStart >= 0,
                  readStart < data.count,
                  readEnd > readStart
            else {
                return nil
            }

            result.append(
                data.subdata(
                    in: readStart..<readEnd
                )
            )

            cursor =
                chunkStart +
                Int64(readEnd)
        }

        return result
    }

    // MARK: - Write

    public func writeChunk(
        key: String,
        offset: Int64,
        data: Data,
        contentType: String? = nil,
        totalLength: Int64? = nil
    ) throws {

        guard !key.isEmpty else {
            throw MediaCacheStoreError.invalidKey
        }

        guard offset >= 0,
              !data.isEmpty
        else {
            throw MediaCacheStoreError.invalidRange
        }

        try ensureRootDirectory()

        let directory =
            entryDirectory(
                key: key
            )

        let chunksDirectory =
            directory.appendingPathComponent(
                "chunks",
                isDirectory: true
            )

        try fileManager.createDirectory(
            at: chunksDirectory,
            withIntermediateDirectories: true
        )

        let chunkURL =
            chunkURL(
                key: key,
                offset: offset
            )

        try data.write(
            to: chunkURL,
            options: .atomic
        )

        var entry =
            try loadEntry(
                key: key
            )
            ??
            MediaCacheEntry(
                key: key
            )

        if let previousLength =
            entry.chunks[offset] {

            entry.cachedByteCount -=
                Int64(
                    previousLength
                )
        }

        entry.chunks[offset] =
            data.count

        entry.cachedByteCount +=
            Int64(
                data.count
            )

        if let contentType {
            entry.contentType =
                contentType
        }

        if let totalLength {
            entry.totalLength =
                totalLength
        }

        entry.lastAccessedAt =
            Date()

        try saveEntry(
            entry
        )
    }

    // MARK: - Metadata

    public func entry(
        key: String
    ) throws -> MediaCacheEntry? {

        try loadEntry(
            key: key
        )
    }

    public func touch(
        key: String
    ) throws {

        guard var entry =
                try loadEntry(
                    key: key
                )
        else {
            return
        }

        entry.lastAccessedAt =
            Date()

        try saveEntry(
            entry
        )
    }

    // MARK: - Remove

    public func remove(
        key: String
    ) throws {

        let directory =
            entryDirectory(
                key: key
            )

        guard fileManager.fileExists(
            atPath: directory.path
        ) else {
            return
        }

        try fileManager.removeItem(
            at: directory
        )
    }

    public func removeAll() throws {

        guard fileManager.fileExists(
            atPath: rootDirectory.path
        ) else {
            return
        }

        try fileManager.removeItem(
            at: rootDirectory
        )
    }

    // MARK: - Eviction

    public func trim(
        to byteLimit: Int64
    ) throws {

        guard byteLimit >= 0 else {
            return
        }

        try ensureRootDirectory()

        let entries =
            try allEntries()

        var totalBytes =
            entries.reduce(
                Int64.zero
            ) {
                $0 + $1.cachedByteCount
            }

        guard totalBytes > byteLimit else {
            return
        }

        let oldestFirst =
            entries.sorted {
                $0.lastAccessedAt <
                $1.lastAccessedAt
            }

        for entry in oldestFirst {

            guard totalBytes > byteLimit else {
                break
            }

            totalBytes -=
                entry.cachedByteCount

            try remove(
                key: entry.key
            )
        }
    }

    // MARK: - Statistics

    public func statistics()
        throws -> MediaCacheStatistics {

        let entries =
            try allEntries()

        return MediaCacheStatistics(
            entryCount:
                entries.count,
            totalBytes:
                entries.reduce(
                    Int64.zero
                ) {
                    $0 + $1.cachedByteCount
                }
        )
    }

    // MARK: - Filesystem

    private func ensureRootDirectory()
        throws {

        try fileManager.createDirectory(
            at: rootDirectory,
            withIntermediateDirectories: true
        )
    }

    private func allEntries()
        throws -> [MediaCacheEntry] {

        try ensureRootDirectory()

        guard let urls =
                fileManager.enumerator(
                    at: rootDirectory,
                    includingPropertiesForKeys: [
                        .isDirectoryKey
                    ],
                    options: [
                        .skipsHiddenFiles
                    ]
                )?.compactMap({
                    $0 as? URL
                })
        else {
            return []
        }

        return try urls
            .filter {
                $0.lastPathComponent ==
                "metadata.json"
            }
            .compactMap {
                try loadMetadata(
                    from: $0
                )
            }
    }

    private func loadEntry(
        key: String
    ) throws -> MediaCacheEntry? {

        let metadataURL =
            metadataURL(
                key: key
            )

        guard fileManager.fileExists(
            atPath: metadataURL.path
        ) else {
            return nil
        }

        return try loadMetadata(
            from: metadataURL
        )
    }

    private func loadMetadata(
        from url: URL
    ) throws -> MediaCacheEntry {

        let data =
            try Data(
                contentsOf: url
            )

        do {
            return try JSONDecoder()
                .decode(
                    MediaCacheEntry.self,
                    from: data
                )
        } catch {
            throw MediaCacheStoreError
                .corruptedEntry
        }
    }

    private func saveEntry(
        _ entry: MediaCacheEntry
    ) throws {

        let directory =
            entryDirectory(
                key: entry.key
            )

        try fileManager.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )

        let url =
            metadataURL(
                key: entry.key
            )

        let data =
            try JSONEncoder()
                .encode(
                    entry
                )

        try data.write(
            to: url,
            options: .atomic
        )
    }

    private func entryDirectory(
        key: String
    ) -> URL {

        rootDirectory
            .appendingPathComponent(
                filesystemIdentifier(
                    key
                ),
                isDirectory: true
            )
    }

    private func metadataURL(
        key: String
    ) -> URL {

        entryDirectory(
            key: key
        )
        .appendingPathComponent(
            "metadata.json"
        )
    }

    private func chunkURL(
        key: String,
        offset: Int64
    ) -> URL {

        entryDirectory(
            key: key
        )
        .appendingPathComponent(
            "chunks",
            isDirectory: true
        )
        .appendingPathComponent(
            "chunk-\(offset).bin"
        )
    }

    private func filesystemIdentifier(
        _ key: String
    ) -> String {

        let data =
            Data(
                key.utf8
            )

        let digest =
            SHA256.hash(
                data: data
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
