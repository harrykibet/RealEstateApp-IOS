//
//  InputState.swift
//  CoreDesignSystem
//
//  Created by builder on 4/6/26.
//

import SwiftUI

public enum InputState: Equatable {
    case normal
    case focused
    case error(string)
    case disabled
}
