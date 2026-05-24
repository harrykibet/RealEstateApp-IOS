//
//  TabPresentation.swift
//  CoreDesignSystem
//
//  Created by builder on 5/23/26.
//

import SwiftUI


public struct TabPresentation: Sendable, Hashable {
    
    public let titleKey: String
    public let iconName: String?
    public let selectedIconName: String?
    
    public init(
        titleKey: String,
        iconName: String? = nil,
        selectedIconName: String? = nil
    ) {
        self.titleKey = titleKey
        self.iconName = iconName
        self.selectedIconName = selectedIconName
    }
}
