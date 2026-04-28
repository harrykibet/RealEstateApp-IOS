//
//  ImageCache.swift
//  CoreImagePipeline
//
//  Created by builder on 4/27/26.
//

import Foundation
import UIKit

public final class ImageMemoryCache {
    
    private let cache = NSCache<WrappedKey, UIImage>()
    
    public init(maxCost: Int = 100 * 1024 * 1024) { // ~100MB
        cache.totalCostLimit = maxCost
    }
    
    public func get(for request: ImageRequest) -> UIImage? {
        cache.object(forKey: WrappedKey(request))
    }
    
    public func set(_ image: UIImage, for request: ImageRequest) {
        let cost = cost(for: image)
        cache.setObject(image, forKey: WrappedKey(request), cost: cost)
    }
    
    private func cost(for image: UIImage) -> Int {
        guard let cgImage = image.cgImage else { return 0 }
        
        return cgImage.bytesPerRow * cgImage.height
    }
}

private final class WrappedKey: NSObject {
    
    private let key: String
    
    init(_ request: ImageRequest) {
        self.key = WrappedKey.makeKey(from: request)
    }
    
    override var hash: Int {
        key.hashValue
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? WrappedKey else { return false }
        return key == other.key
    }
}

private extension WrappedKey {
    
    static func makeKey(from request: ImageRequest) -> String {
        var key = request.url.absoluteString
        
        if let size = request.targetSize {
            key += "_\(Int(size.width))x\(Int(size.height))"
        }
        
        key += "_\(request.contentMode)"
        
        return key
    }
}
