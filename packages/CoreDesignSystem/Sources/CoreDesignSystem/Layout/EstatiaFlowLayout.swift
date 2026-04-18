//
//  EstatiaFlowLayout.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//


import SwiftUI

public struct EstatiaFlowLayout: Layout {
    
    public var spacing: CGFloat
    public var lineSpacing: CGFloat
    
    public init(
        spacing: CGFloat = 8,
        lineSpacing: CGFloat = 8
    ) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
    }
    
    // MARK: - Cache
    
    public struct Cache {
        var sizes: [CGSize] = []
    }
    
    public func makeCache(subviews: Subviews) -> Cache {
        Cache(sizes: subviews.map { $0.sizeThatFits(.unspecified) })
    }
    
    public func updateCache(_ cache: inout Cache, subviews: Subviews) {
        cache.sizes = subviews.map { $0.sizeThatFits(.unspecified) }
    }
}