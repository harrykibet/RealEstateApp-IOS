//
//  Loader.swift
//  CoreDesignSystem
//
//  Created by builder on 4/27/26.
//

import Foundation
import CoreImagePipeline
import CoreMediaPipeline
import SwiftUI

final class Loader: ObservableObject {
    
    @Published private(set) var state: EstatiaAsyncImageState = .idle
    
    private let url: URL?
    private let pipeline: ImagePipeline
    
    private var task: Task<Void, Never>?
    
    init(url: URL?, pipeline: ImagePipeline) {
        self.url = url
        self.pipeline = pipeline
    }
    
    func load(targetSize: CGSize? = nil,
              contentMode: ImageContentMode = .fill,
              priority: MediaPriority = .normal,
              cachePolicy: MediaCachePolicy = .default) {
        
        guard let url, task == nil else { return }

        state = .loading

        let request = ImageRequest(
            url: url,
            targetSize: targetSize,
            contentMode: contentMode,
            priority: priority,
            cachePolicy: cachePolicy
        )

        task = Task {
            do {
                let image = try await pipeline.load(request)

                if Task.isCancelled { return }

                await MainActor.run {
                    self.state = .success(Image(uiImage: image))
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
