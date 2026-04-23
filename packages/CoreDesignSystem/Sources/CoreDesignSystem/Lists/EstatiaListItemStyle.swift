//
//  EstatiaListItemStyle.swift
//  CoreDesignSystem
//
//  Created by builder on 4/22/26.
//

import SwiftUI

public struct EstatiaListItemStyle: Sendable {
    
    public let showsDivider: Bool
    public let showsChevron: Bool
    public let verticalPadding: CGFloat
    public let isDestructive: Bool
    public let dividerInset: DividerInset?
    
    public init(
        showsDivider: Bool = true,
        showsChevron: Bool = false,
        verticalPadding: CGFloat,
        isDestructive: Bool = false,
        dividerInset : DividerInset = nil
    ) {
        self.showsDivider = showsDivider
        self.showsChevron = showsChevron
        self.verticalPadding = verticalPadding
        self.isDestructive = isDestructive
        self.dividerInset = dividerInset
    }
}

public extension EstatiaListItemStyle {
    
    static let standard = EstatiaListItemStyle(
        verticalPadding: 12,
        dividerInset: .leading
    )
    
    static let compact = EstatiaListItemStyle(
        verticalPadding: 8,
        dividerInset: .leading
    )
    
    static let navigation = EstatiaListItemStyle(
        showsChevron: true,
        verticalPadding: 12,
        dividerInset: .leading
    )
    
    static let destructive = EstatiaListItemStyle(
        verticalPadding: 12,
        isDestructive: true,
        dividerInset: .none
    )
}
