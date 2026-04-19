//
//  EstatiaProgressState.swift
//  CoreDesignSystem
//
//  Created by builder on 4/19/26.
//


public enum EstatiaProgressState: Sendable, Equatable {

    case idle

    /// Unknown duration (spinner-like bar)
    case indeterminate

    /// Known progress
    case determinate(value: Double)

    /// Streaming / prefetch scenario
    case buffered(value: Double, buffer: Double)

    /// Terminal states
    case success
    case error
}