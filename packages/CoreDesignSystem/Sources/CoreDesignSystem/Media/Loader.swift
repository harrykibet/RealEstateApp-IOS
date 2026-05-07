//
//  Loader.swift
//  CoreDesignSystem
//
//  Created by builder on 4/27/26.
//

import Foundation
import SwiftUI
import CoreImagePipeline
import CoreMediaPipeline

@MainActor
final class Loader: ObservableObject {
    
    // MARK: - State
    
    @Published private(set) var state: EstatiaAsyncImageState = .idle
    
    // MARK: - Dependencies
    
    private let pipeline: ImagePipeline
    
    // MARK: - Request Lifecycle
    
    private var task: Task<Void, Never>?
    
    /// Monotonically increasing token used to invalidate stale completions.
    ///
    /// Prevents older requests from overriding newer UI state.
    private var requestID: UInt64 = 0
    
    /// Current URL associated with the active request.
    ///
    /// Useful for deduplication and avoiding unnecessary reloads.
    private var currentURL: URL?
    
    // MARK: - Init
    
    init(pipeline: ImagePipeline) {
        self.pipeline = pipeline
    }
    
    deinit {
        task?.cancel()
    }
    
    // MARK: - Public API
    
    func load(
        url: URL?,
        targetSize: CGSize? = nil,
        contentMode: ImageContentMode = .fill,
        priority: MediaPriority = .normal,
        cachePolicy: MediaCachePolicy = .default,
        forceReload: Bool = false
    ) {
        
        guard let url else {
            reset()
            return
        }
        
        // Prevent unnecessary duplicate loads.
        //
        // Important for:
        // - SwiftUI body re-evaluations
        // - Lazy grids/lists
        // - rapid view invalidation cycles
        if !forceReload,
           currentURL == url,
           task != nil
        {
            return
        }
        
        cancel()
        
        currentURL = url
        state = .loading
        
        requestID &+= 1
        let activeRequestID = requestID
        
        let request = ImageRequest(
            url: url,
            targetSize: targetSize,
            contentMode: contentMode,
            priority: priority,
            cachePolicy: cachePolicy
        )
        
        task = Task { [weak self] in
            
            guard let self else { return }
            
            do {
                
                let image = try await pipeline.load(request)
                
                guard !Task.isCancelled else { return }
                
                // Prevent stale request races:
                //
                // Request A starts
                // Request B starts
                // B finishes
                // A finishes later -> must NOT override B
                guard activeRequestID == requestID else {
                    return
                }
                
                state = .success(Image(uiImage: image))
                
            } catch is CancellationError {
                
                // Expected lifecycle event.
                // Avoid transitioning into failure state.
                
            } catch {
                
                guard !Task.isCancelled else { return }
                
                guard activeRequestID == requestID else {
                    return
                }
                
                state = .failure(error)
            }
            
            // Clear task only if this is still
            // the currently active request.
            if activeRequestID == requestID {
                task = nil
            }
        }
    }
    
    func cancel(resetState: Bool = false) {
        
        task?.cancel()
        task = nil
        
        if resetState {
            state = .idle
        }
    }
    
    func reset() {
        cancel(resetState: true)
        currentURL = nil
    }
}
