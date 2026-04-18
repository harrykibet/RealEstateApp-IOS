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
    
    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGSize {
        
        let maxWidth = proposal.width ?? .infinity
        
        var currentRowWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        
        var totalHeight: CGFloat = 0
        var maxRowWidth: CGFloat = 0
        
        for size in cache.sizes {
            
            if currentRowWidth + size.width > maxWidth {
                // move to next line
                totalHeight += currentRowHeight + lineSpacing
                maxRowWidth = max(maxRowWidth, currentRowWidth)
                
                currentRowWidth = size.width + spacing
                currentRowHeight = size.height
            } else {
                currentRowWidth += size.width + spacing
                currentRowHeight = max(currentRowHeight, size.height)
            }
        }
        
        // finalize last row
        totalHeight += currentRowHeight
        maxRowWidth = max(maxRowWidth, currentRowWidth)
        
        return CGSize(width: maxRowWidth, height: totalHeight)
    }
}
