//
//  PrefetchQueue.swift
//  CoreImagePipeline
//
//  Created by builder on 4/28/26.
//


public actor PrefetchQueue {
    
    private let pipeline: ImagePipeline
    
    public init(pipeline: ImagePipeline) {
        self.pipeline = pipeline
    }
    
    public func prefetch(_ requests: [ImageRequest]) {
        for request in requests {
            Task {
                _ = try? await pipeline.load(request)
            }
        }
    }
}