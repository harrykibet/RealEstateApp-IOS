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
    
    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) {
        
        let maxWidth = bounds.width
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for index in subviews.indices {
            
            let size = cache.sizes[index]
            
            if x + size.width > maxWidth {
                // wrap to next line
                x = 0
                y += rowHeight + lineSpacing
                rowHeight = 0
            }
            
            subviews[index].place(
                at: CGPoint(x: bounds.minX + x, y: bounds.minY + y),
                proposal: ProposedViewSize(size)
            )
            
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }}
