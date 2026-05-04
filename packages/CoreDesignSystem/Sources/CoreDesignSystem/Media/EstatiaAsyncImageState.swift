//
//  EstatiaAsyncImageState.swift
//  CoreDesignSystem
//
//  Created by builder on 4/27/26.
//

import SwiftUI


public enum EstatiaAsyncImageState: Equatable {
    case idle
    case loading
    case success(Image)
    case failure(Error)
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
            
        case (.loading, .loading):
            return true
            
        case (.success, .success):
            return true
            
        case (.failure, .failure):
            return true
            
        default:
            return false
        }
    }
}
