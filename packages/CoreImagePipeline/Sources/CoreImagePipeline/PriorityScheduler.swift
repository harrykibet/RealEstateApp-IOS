//
//  PriorityScheduler.swift
//  CoreImagePipeline
//
//  Created by builder on 4/28/26.
//


public actor PriorityScheduler {
    
    func schedule<T>(
        _ task: Task<T, Error>,
        priority: MediaPriority
    ) async throws -> T {
        
        switch priority {
        case .high:
            return try await task.value
            
        case .normal:
            return try await task.value
            
        case .low:
            try await Task.sleep(nanoseconds: 50_000_000) // small delay
            return try await task.value
        }
    }
}