//
//  EstatiaDivider.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

public struct EstatiaDivider: View {
    let inset: CGFloat?
    
    public var body: some View {
        Rectangle()
            .fill(theme.colors.separator)
            .frame(height: theme.dimensions.dividerThickness)
            .padding(.leading, inset ?? 0)
    }
}
