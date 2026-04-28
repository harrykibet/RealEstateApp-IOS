//
//  ImageDiskCache.swift
//  CoreImagePipeline
//
//  Created by builder on 4/28/26.
//

import Foundation
import SwiftUI


actor ImageDiskCache {
    
    private let directory: URL
    
    func get(for request: ImageRequest) async throws -> Data? {
        let url = fileURL(for: request)
        return try? Data(contentsOf: url)
    }
    
    func set(_ data: Data, for request: ImageRequest) async {
        let url = fileURL(for: request)
        try? data.write(to: url)
    }
}
