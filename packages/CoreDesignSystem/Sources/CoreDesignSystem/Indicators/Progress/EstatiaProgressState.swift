//
//  EstatiaProgressState.swift
//  CoreDesignSystem
//
//  Created by builder on 4/19/26.
//


public enum EstatiaProgressState: Sendable, Equatable {

    case idle
    
    case indeterminate
    
    case determinate(value: Double)
    
    case buffered(value: Double, buffer: Double)
    
    case success
    
    case error(reason: Error?)
}
