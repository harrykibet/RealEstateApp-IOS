//
//  ImageDiskCache.swift
//  CoreImagePipeline
//
//  Created by builder on 4/28/26.
//

import Foundation
import CoreMediaPipeline
import CoreSecurity

public actor ImageDiskCache {
    
    private let directory: URL
    private let fileManager: FileManager
    
    // MARK: - Init
    
    public init(
        directory: URL? = nil,
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager
        
        if let directory {
            self.directory = directory
        } else {
            let base = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            self.directory = base.appendingPathComponent("image_cache", isDirectory: true)
        }
        
        createDirectoryIfNeeded(
            at: self.directory,
            fileManager: self.fileManager
        )
    }
    
    nonisolated private func createDirectoryIfNeeded(
        at directory: URL,
        fileManager: FileManager
    ) {
        if !fileManager.fileExists(atPath: directory.path) {
            do {
                try fileManager.createDirectory(
                    at: directory,
                    withIntermediateDirectories: true
                )
            } catch {
                assertionFailure("Failed to create disk cache directory: \(error)")
            }
        }
    }
    
    private func fileURL(for request: ImageRequest) -> URL {
        let key = cacheKey(for: request)
        return directory.appendingPathComponent(key)
    }
    
    private func cacheKey(for request: ImageRequest) -> String {
        var key = request.url.absoluteString
        
        if let size = request.targetSize {
            key += "_\(Int(size.width))x\(Int(size.height))"
        }
        
        // Hash it to make it filesystem-safe
        return sha256(key)
    }
    
    public func get(for request: ImageRequest) async throws -> Data? {
        let url = fileURL(for: request)
        
        guard fileManager.fileExists(atPath: url.path) else {
            return nil
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            throw MediaError.cacheReadFailed
        }
    }
    
    public func set(_ data: Data, for request: ImageRequest) async throws {
        let url = fileURL(for: request)
        
        do {
            try data.write(to: url, options: .atomic)
        } catch {
            throw MediaError.cacheWriteFailed
        }
    }
}
