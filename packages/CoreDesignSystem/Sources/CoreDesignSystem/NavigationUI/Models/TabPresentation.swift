//
//  TabPresentation.swift
//  CoreDesignSystem
//
//  Created by builder on 5/23/26.
//

import SwiftUI


public struct TabPresentation: Sendable, Hashable {
    public let title: LocalizedStringKey
    public let icon: ImageResource
    public let selectedIcon: ImageResource?
}
