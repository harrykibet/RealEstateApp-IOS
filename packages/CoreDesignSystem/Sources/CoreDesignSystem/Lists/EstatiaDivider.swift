//
//  EstatiaDivider.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaDivider: View {
    let inset: CGFloat?
    
    @Environment(\.theme) private var theme
    
    public var body: some View {
        Rectangle()
            .fill(theme.colors.separator)
            .frame(height: theme.dimensions.stroke.hairline)
            .padding(.leading, inset ?? 0)
    }
}
