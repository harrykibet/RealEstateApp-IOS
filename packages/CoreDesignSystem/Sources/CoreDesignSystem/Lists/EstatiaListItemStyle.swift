//
//  EstatiaListItemStyle.swift
//  CoreDesignSystem
//
//  Created by builder on 4/22/26.
//


public struct EstatiaListItemStyle: Sendable {
    
    public let showsDivider: Bool
    public let showsChevron: Bool
    public let verticalPadding: CGFloat
    public let isDestructive: Bool
    
    public init(
        showsDivider: Bool = true,
        showsChevron: Bool = false,
        verticalPadding: CGFloat,
        isDestructive: Bool = false
    ) {
        self.showsDivider = showsDivider
        self.showsChevron = showsChevron
        self.verticalPadding = verticalPadding
        self.isDestructive = isDestructive
    }
}

public extension EstatiaListItemStyle {
    
    static let standard = EstatiaListItemStyle(
        verticalPadding: 12
    )
    
    static let compact = EstatiaListItemStyle(
        verticalPadding: 8
    )
    
    static let navigation = EstatiaListItemStyle(
        showsChevron: true,
        verticalPadding: 12
    )
    
    static let destructive = EstatiaListItemStyle(
        verticalPadding: 12,
        isDestructive: true
    )
}
