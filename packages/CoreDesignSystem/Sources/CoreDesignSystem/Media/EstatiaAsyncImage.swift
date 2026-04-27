//
//  EstatiaAsyncImage.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaAsyncImage: View {
    
    @StateObject private var loader: Loader
    
    private let contentMode: ContentMode
    
    public init(
        url: URL?,
        pipeline: ImagePipeline,
        contentMode: ContentMode = .fill
    ) {
        _loader = StateObject(
            wrappedValue: Loader(url: url, pipeline: pipeline)
        )
        self.contentMode = contentMode
    }
    
    public var body: some View {
        content
            .onAppear { loader.load() }
            .onDisappear { loader.cancel() }
    }
    
    @ViewBuilder
    private var content: some View {
        switch loader.state {
        case .idle, .loading:
            EstatiaLoadingView()
            
        case .success(let image):
            EstatiaImage(image: image, contentMode: contentMode)
            
        case .failure:
            EstatiaErrorView(message: "Error loading image")
        }
    }
}
