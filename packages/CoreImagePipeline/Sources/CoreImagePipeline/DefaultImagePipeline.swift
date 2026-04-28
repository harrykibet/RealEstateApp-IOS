//
//  DefaultImagePipeline.swift
//  CoreImagePipeline
//
//  Created by builder on 4/27/26.
//

import UIKit
import CoreMedia

public actor DefaultImagePipeline: ImagePipeline {
    
    private var inFlightTasks: [ImageRequest: Task<UIImage, Error>] = [:]
    
    private let memoryCache: ImageMemoryCache
    private let diskCache: ImageDiskCache
    private let network: NetworkClient
    private let decoder: ImageDecoder
    private let scheduler: PriorityScheduler
    
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
    
    private func applyWritePolicy(
        data: Data,
        image: UIImage,
        for request: ImageRequest
    ) async {
        
        switch request.cachePolicy.write {
            
        case .none:
            break
            
        case .memory:
            memoryCache.set(image, for: request)
            
        case .disk:
            await diskCache.set(data, for: request)
            
        case .memoryAndDisk:
            memoryCache.set(image, for: request)
            await diskCache.set(data, for: request)
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
    
    public func load(_ request: ImageRequest) async throws -> UIImage {
        
        // 1. Memory cache
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
        
        let task = Task<UIImage, Error> {
            defer { await self.removeTask(for: request) }
            
            // 3. Disk cache
            if request.cachePolicy.read == .disk ||
               request.cachePolicy.read == .memoryThenDisk {
                
                if let data = try? await diskCache.get(for: request),
                   let image = try? decoder.decode(data, targetSize: request.targetSize) {
                    
                    // Promote to memory ONLY if policy allows
                    if shouldWriteToMemory(request.cachePolicy.write) {
                        memoryCache.set(image, for: request)
                    }
                    
                    return image
                }
            }
            
            // 4. Network
            let (data, _) = try await network.fetch(request.url)
            
            // 5. Decode
            let image = try decoder.decode(data, targetSize: request.targetSize)
            
            // 6. Apply write policy (FIXED)
            await applyWritePolicy(data: data, image: image, for: request)
            
            return image
        }
        
        inFlightTasks[request] = task
        
        return try await scheduler.schedule(task, priority: request.priority)
    }
    
    private func removeTask(for request: ImageRequest) {
        inFlightTasks[request] = nil
    }
}
