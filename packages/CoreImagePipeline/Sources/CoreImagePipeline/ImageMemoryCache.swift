//
//  ImageCache.swift
//  CoreImagePipeline
//
//  Created by builder on 4/27/26.
//

public final class ImageMemoryCache {
    
    private let cache = NSCache<WrappedKey, UIImage>()
    
    public func get(for request: ImageRequest) -> UIImage? {
        cache.object(forKey: WrappedKey(request))
    }
    
    public func set(_ image: UIImage, for request: ImageRequest) {
        cache.setObject(image, forKey: WrappedKey(request))
    }
}


