//
//  EstatiaAvatar.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaAvatar: View {
    
    private let url: URL?
    private let size: CGFloat
    private let pipeline: ImagePipeline
    
    public init(
        url: URL?,
        size: CGFloat,
        pipeline: ImagePipeline
    ) {
        self.url = url
        self.size = size
        self.pipeline = pipeline
    }
    
    public var body: some View {
        EstatiaAsyncImage(
            url: url,
            pipeline: pipeline
        )
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(.white, lineWidth: 2))
    }
}
