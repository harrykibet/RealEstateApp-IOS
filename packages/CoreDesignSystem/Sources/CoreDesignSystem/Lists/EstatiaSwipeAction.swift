//
//  EstatiaSwipeAction.swift
//  CoreDesignSystem
//
//  Created by builder on 4/22/26.
//

import SwiftUI


public struct EstatiaSwipeAction: Sendable {
    
    public let title: String
    public let role: Role
    public let action: @Sendable () -> Void
    
    public enum Role : Sendable {
        case normal
        case destructive
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
