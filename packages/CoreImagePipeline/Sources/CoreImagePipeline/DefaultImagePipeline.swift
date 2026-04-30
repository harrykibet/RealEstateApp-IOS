//
//  DefaultImagePipeline.swift
//  CoreImagePipeline
//

import UIKit
import CoreNetwork
import CoreMedia

public actor DefaultImagePipeline: ImagePipeline {
    
    // MARK: - State
    
    private var inFlightTasks: [ImageRequest: Task<UIImage, Error>] = [:]
    
    private let memoryCache: ImageMemoryCache
    private let diskCache: ImageDiskCache
    private let network: NetworkClient
    private let decoder: ImageDecoder
    private let scheduler: PriorityScheduler
    
    // MARK: - Init
    
    public init(
        memoryCache: ImageMemoryCache,
        diskCache: ImageDiskCache,
        network: NetworkClient,
        decoder: ImageDecoder,
        scheduler: PriorityScheduler
    ) {
        self.memoryCache = memoryCache
        self.diskCache = diskCache
        self.network = network
        self.decoder = decoder
        self.scheduler = scheduler
    }
    
    // MARK: - Public API
    
    public func load(_ request: ImageRequest) async throws -> UIImage {
        
        // 1. Memory Cache (fast path)
        if request.cachePolicy.read == .memory ||
           request.cachePolicy.read == .memoryThenDisk {
            
            if let cached = memoryCache.get(for: request) {
                return cached
            }
        }
        
        // 2. Deduplication
        if let existingTask = inFlightTasks[request] {
            return try await existingTask.value
        }
        
        // 3. Create Task
        let task = Task<UIImage, Error> {
            do {
                let result = try await self.loadInternal(request)
                await self.removeTask(for: request)
                return result
            } catch {
                await self.removeTask(for: request)
                throw error
            }
        }
        
        inFlightTasks[request] = task
        
        // 4. Priority Scheduling
        return try await scheduler.schedule(task, priority: request.priority)
    }
    
    public func prefetch(_ requests: [ImageRequest]) async {
        for request in requests {
            Task {
                _ = try? await load(request)
            }
        }
    }
    
    public func cancel(_ request: ImageRequest) async {
        inFlightTasks[request]?.cancel()
        inFlightTasks[request] = nil
    }
    
    // MARK: - Core Logic
    
    private func loadInternal(_ request: ImageRequest) async throws -> UIImage {
        
        // MARK: Disk Cache
        
        if request.cachePolicy.read == .disk ||
           request.cachePolicy.read == .memoryThenDisk {
            
            do {
                if let data = try await diskCache.get(for: request) {
                    
                    if Task.isCancelled {
                        throw MediaError.cancelled
                    }
                    
                    do {
                        let image = try decoder.decode(
                            data,
                            targetSize: request.targetSize
                        )
                        
                        if shouldWriteToMemory(request.cachePolicy.write) {
                            memoryCache.set(image, for: request)
                        }
                        
                        return image
                        
                    } catch {
                        throw MediaError.decodingFailed(underlying: error)
                    }
                }
            } catch {
                // Disk failure should not fail pipeline
                // TODO: log error
            }
        }
        
        // MARK: Network
        
        let data: Data
        
        do {
            let (fetchedData, response) = try await network.fetch(request.url)
            
            guard let http = response as? HTTPURLResponse else {
                throw MediaError.invalidResponse
            }
            
            guard (200...299).contains(http.statusCode) else {
                throw MediaError.unacceptableStatusCode(http.statusCode)
            }
            
            guard !fetchedData.isEmpty else {
                throw MediaError.emptyData
            }
            
            data = fetchedData
            
        } catch is CancellationError {
            throw MediaError.cancelled
        } catch let error as MediaError {
            throw error
        } catch {
            throw MediaError.requestFailed(underlying: error)
        }
        
        if Task.isCancelled {
            throw MediaError.cancelled
        }
        
        // MARK: Decode
        
        let image: UIImage
        
        do {
            image = try decoder.decode(
                data,
                targetSize: request.targetSize
            )
        } catch {
            throw MediaError.decodingFailed(underlying: error)
        }
        
        if Task.isCancelled {
            throw MediaError.cancelled
        }
        
        // MARK: Write Cache
        
        do {
            try await applyWritePolicy(
                data: data,
                image: image,
                for: request
            )
        } catch {
            // Cache write failure should not break flow
            // TODO: log error
        }
        
        return image
    }
    
    // MARK: - Helpers
    
    private func applyWritePolicy(
        data: Data,
        image: UIImage,
        for request: ImageRequest
    ) async throws {
        
        switch request.cachePolicy.write {
            
        case .none:
            break
            
        case .memory:
            memoryCache.set(image, for: request)
            
        case .disk:
            try await diskCache.set(data, for: request)
            
        case .memoryAndDisk:
            memoryCache.set(image, for: request)
            try await diskCache.set(data, for: request)
        }
    }
    
    private func shouldWriteToMemory(_ policy: MediaCachePolicy.Write) -> Bool {
        switch policy {
        case .memory, .memoryAndDisk:
            return true
        default:
            return false
        }
    }
    
    private func removeTask(for request: ImageRequest) {
        inFlightTasks[request] = nil
    }
}
