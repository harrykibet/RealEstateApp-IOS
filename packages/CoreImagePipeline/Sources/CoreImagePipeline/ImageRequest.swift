//
//  ImageRequest.swift
//  CoreImagePipeline
//
//  Created by builder on 4/27/26.
//

import Foundation
import SwiftUI


public struct ImageRequest: Hashable, Sendable {
    public let url: URL
    public let targetSize: CGSize?
    public let contentMode: ContentMode
    public let priority: MediaPriority
    public let cachePolicy: MediaCachePolicy
    
    public init(
        url: URL,
        targetSize: CGSize? = nil,
        contentMode: ContentMode = .fill,
        priority: MediaPriority = .normal,
        cachePolicy: MediaCachePolicy = .default
    ) {
        self.url = url
        self.targetSize = targetSize
        self.contentMode = contentMode
        self.priority = priority
        self.cachePolicy = cachePolicy
    }
}
