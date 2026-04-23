//
//  DividerInset.swift
//  CoreDesignSystem
//
//  Created by builder on 4/23/26.
//

import CoreGraphics

public enum DividerInset: Sendable {
    case automatic
    case leading
    case custom(CGFloat)
    case none
}
