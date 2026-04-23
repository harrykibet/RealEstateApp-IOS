//
//  EstatiaList.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaList<Content: View>: View {
    
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                content
            }
        }
    }
}

extension EstatiaList {
    
    static func resolveInset(for style: EstatiaListItemStyle) -> CGFloat {
        
        guard style.showsDivider else { return 0 }
        
        guard let inset = style.dividerInset else {
            return defaultInset(for: style)
        }
        
        switch inset {
        case .none:
            return 0
        case .custom(let value):
            return value
        case .leading, .automatic:
            return defaultInset(for: style)
        }
    }
    
    static func defaultInset(for style: EstatiaListItemStyle) -> CGFloat {
        36
    }
}
