// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public protocol ImagePipeline: Sendable {
    func load(_ request: ImageRequest) async throws -> UIImage
    func prefetch(_ requests: [ImageRequest])
    func cancel(_ request: ImageRequest)
}
