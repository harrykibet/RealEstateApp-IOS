//
//  EstatiaListLayout.swift
//  CoreDesignSystem
//
//  Created by builder on 4/25/26.
//

import SwiftUI

public enum EstatiaListLayout {
    
    public static func resolveInset(for style: EstatiaListItemStyle) -> CGFloat {
        
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
    
    private static func defaultInset(for style: EstatiaListItemStyle) -> CGFloat {
        36
    }
}
