//
//  EstatiaProgressState.swift
//  CoreDesignSystem
//
//  Created by builder on 4/19/26.
//


public enum EstatiaProgressState: Sendable {
    
    case idle
    case indeterminate
    case determinate(value: Double)
    case buffered(value: Double, buffer: Double)
    case success
    case error(reason: Error?)
}

// MARK: - Equatable

extension EstatiaProgressState: Equatable {
    
    public static func == (lhs: EstatiaProgressState, rhs: EstatiaProgressState) -> Bool {
        switch (lhs, rhs) {
            
        case (.idle, .idle):
            return true
            
        case (.indeterminate, .indeterminate):
            return true
            
        case let (.determinate(l), .determinate(r)):
            return l == r
            
        case let (.buffered(lv, lb), .buffered(rv, rb)):
            return lv == rv && lb == rb
            
        case (.success, .success):
            return true
            
        case (.error, .error):
            // ⚠️ Intentionally ignore associated Error
            return true
            
        default:
            return false
        }
    }
}
