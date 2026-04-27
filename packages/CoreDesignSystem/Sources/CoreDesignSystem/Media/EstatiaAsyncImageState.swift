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
}
