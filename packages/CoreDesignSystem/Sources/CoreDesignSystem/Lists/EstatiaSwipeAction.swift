//
//  EstatiaSwipeAction.swift
//  CoreDesignSystem
//
//  Created by builder on 4/22/26.
//

import SwiftUI


import SwiftUI

@MainActor
public struct EstatiaSwipeAction {
    
    public let title: String
    public let role: Role
    public let action: @MainActor () -> Void
    
    public enum Role {
        case normal
        case destructive
    }
    
    public init(
        title: String,
        role: Role = .normal,
        action: @escaping @MainActor () -> Void
    ) {
        self.title = title
        self.role = role
        self.action = action
    }
}

public extension View {
    
    func estatiaSwipeActions(
        _ actions: [EstatiaSwipeAction]
    ) -> some View {
        self.swipeActions {
            ForEach(actions.indices, id: \.self) { index in
                let action = actions[index]
                
                Button(action.title) {
                    action.action()
                }
                .tint(action.role == .destructive ? .red : .blue)
            }
        }
    }
}
