//
//  MediaRequest.swift
//  CoreMedia
//
//  Created by builder on 4/27/26.
//

import Foundation

public struct MediaRequest {
    public let url: URL
    public let priority: MediaPriority
    public let cachePolicy: MediaCachePolicy
}
