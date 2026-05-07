//
//  EstatiaAsyncImage.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI
import CoreImagePipeline
import CoreMediaPipeline

public struct EstatiaAsyncImage: View {
    
    // MARK: - State
    
    @StateObject private var loader: Loader
    
    // MARK: - Configuration
    
    private let url: URL?
    private let contentMode: ContentMode
    
    private let targetSize: CGSize?
    private let imageContentMode: ImageContentMode
    private let priority: MediaPriority
    private let cachePolicy: MediaCachePolicy
    
    // MARK: - Init
    
    public init(
        url: URL?,
        pipeline: ImagePipeline,
        contentMode: ContentMode = .fill,
        targetSize: CGSize? = nil,
        imageContentMode: ImageContentMode = .fill,
        priority: MediaPriority = .normal,
        cachePolicy: MediaCachePolicy = .default
    ) {
        self.url = url
        self.contentMode = contentMode
        self.targetSize = targetSize
        self.imageContentMode = imageContentMode
        self.priority = priority
        self.cachePolicy = cachePolicy
        
        _loader = StateObject(
            wrappedValue: Loader(pipeline: pipeline)
        )
    }
    
    // MARK: - Body
    
    public var body: some View {
        content
            .task(id: requestIdentity) {
                loader.load(
                    url: url,
                    targetSize: targetSize,
                    contentMode: imageContentMode,
                    priority: priority,
                    cachePolicy: cachePolicy
                )
            }
            .onDisappear {
                loader.cancel()
            }
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private var content: some View {
        switch loader.state {
            
        case .idle,
             .loading:
            
            EstatiaLoadingView()
            
        case .success(let image):
            
            EstatiaImage(
                image: image,
                contentMode: contentMode
            )
            
        case .failure:
            
            EstatiaErrorView(
                message: "Error loading image"
            )
        }
    }
    
    // MARK: - Request Identity
    
    /// Stable identity used to restart loading only
    /// when meaningful request inputs change.
    ///
    /// Important for SwiftUI task lifecycle correctness.
    private var requestIdentity: RequestIdentity {
        RequestIdentity(
            url: url,
            targetSize: targetSize,
            contentMode: imageContentMode,
            priority: priority,
            cachePolicy: cachePolicy
        )
    }
}

// MARK: - RequestIdentity

private struct RequestIdentity: Hashable {
    
    let url: URL?
    let targetSize: CGSize?
    let contentMode: ImageContentMode
    let priority: MediaPriority
    let cachePolicy: MediaCachePolicy
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        
        hasher.combine(targetSize?.width)
        hasher.combine(targetSize?.height)
        
        hasher.combine(contentMode)
        hasher.combine(priority)
        hasher.combine(cachePolicy)
    }
    
    static func == (
        lhs: RequestIdentity,
        rhs: RequestIdentity
    ) -> Bool {
        
        lhs.url == rhs.url &&
        lhs.targetSize?.width == rhs.targetSize?.width &&
        lhs.targetSize?.height == rhs.targetSize?.height &&
        lhs.contentMode == rhs.contentMode &&
        lhs.priority == rhs.priority &&
        lhs.cachePolicy == rhs.cachePolicy
    }
}
