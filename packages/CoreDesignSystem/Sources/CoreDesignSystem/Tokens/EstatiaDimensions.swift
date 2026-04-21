//
//  EstatiaDimensions.swift
//  CoreDesignSystem
//
//  Created by builder on 4/21/26.
//


public struct EstatiaDimensions: AppDimensions {
    public let spacing = Spacing()
    public let sizing = Sizing()
    public let radius = Radius()
    public let stroke = Stroke()
    public let elevation = Elevation()
    
    public init() {}
}

public extension AppDimensions where Self == EstatiaDimensions {
    static var estatia: EstatiaDimensions {
        EstatiaDimensions()
    }
}
