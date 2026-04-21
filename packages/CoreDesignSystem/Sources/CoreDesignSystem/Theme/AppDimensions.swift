//
//  AppDimensions.swift
//  CoreDesignSystem
//
//  Created by builder on 4/21/26.
//


public protocol AppDimensions {
    
    // MARK: - Spacing
    var spacing: Spacing { get }
    
    // MARK: - Sizing
    var sizing: Sizing { get }
    
    // MARK: - Radius
    var radius: Radius { get }
    
    // MARK: - Stroke / Divider
    var stroke: Stroke { get }
    
    // MARK: - Elevation (future-proofing)
    var elevation: Elevation { get }
}