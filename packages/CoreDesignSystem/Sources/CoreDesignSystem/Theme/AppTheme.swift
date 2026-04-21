//
//  AppTheme.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

@MainActor
public protocol AppTheme {
    var colors: AppSemanticColors { get }
    var typography: AppTypography { get }
    var dimensions: AppDimensions { get }
}
