//
//  Loader.swift
//  CoreDesignSystem
//
//  Created by builder on 4/27/26.
//

import Foundation
import CoreImagePipeline

final class Loader: ObservableObject {
    
    @Published private(set) var state: EstatiaAsyncImageState = .idle
    
    private let url: URL?
    private let pipeline: ImagePipeline
    
    private var task: Task<Void, Never>?
    
    init(url: URL?, pipeline: ImagePipeline) {
        self.url = url
        self.pipeline = pipeline
    }
    
    func load() {
        guard let url, task == nil else { return }
        
        state = .loading
        
        task = Task {
            do {
                let image = try await pipeline.loadImage(from: url)
                
                if Task.isCancelled { return }
                
                await MainActor.run {
                    self.state = .success(image)
                }
                
            } catch {
                if Task.isCancelled { return }
                
                await MainActor.run {
                    self.state = .failure(error)
                }
            }
        }
    }
    
    func cancel() {
        task?.cancel()
        task = nil
    }
}
