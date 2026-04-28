//
//  DefaultImagePipeline.swift
//  CoreImagePipeline
//
//  Created by builder on 4/27/26.
//

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
    
    public func load(_ request: ImageRequest) async throws -> UIImage {
        
        // 1. Memory cache (FAST PATH)
        if let cached = memoryCache.get(for: request) {
            return cached
        }
        
        // 2. Deduplication
        if let existingTask = inFlightTasks[request] {
            return try await existingTask.value
        }
        
        // 3. Create new task
        let task = Task<UIImage, Error> {
            defer { await self.removeTask(for: request) }
            
            // Disk cache
            if let data = try? await diskCache.get(for: request),
               let image = try? decoder.decode(data, targetSize: request.targetSize) {
                
                memoryCache.set(image, for: request)
                return image
            }
            
            // Network
            let (data, _) = try await network.fetch(request.url)
            
            // Store to disk (async, non-blocking)
            Task.detached {
                await self.diskCache.set(data, for: request)
            }
            
            // Decode
            let image = try decoder.decode(data, targetSize: request.targetSize)
            
            // Store to memory
            memoryCache.set(image, for: request)
            
            return image
        }
        
        inFlightTasks[request] = task
        
        return try await scheduler.schedule(task, priority: request.priority)
    }
    
    private func removeTask(for request: ImageRequest) {
        inFlightTasks[request] = nil
    }
}
