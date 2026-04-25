//
//  EstatiaSwipeAction.swift
//  CoreDesignSystem
//
//  Created by builder on 4/22/26.
//

import SwiftUI


public struct EstatiaSwipeAction: Identifiable {
    
    public let id: AnyHashable
    public let title: String
    public let role: Role
    public let action: @MainActor () async -> Void
    
    public enum Role {
        case normal
        case destructive
    }
    
    public init<ID: Hashable>(
        id: ID,
        title: String,
        role: Role = .normal,
        action: @escaping @MainActor () async -> Void
    ) {
        self.id = AnyHashable(id)
        self.title = title
        self.role = role
        self.action = action
    }
}

public extension View {
    
    func estatiaSwipeActions(
        _ actions: [EstatiaSwipeAction]
    ) -> some View {
        swipeActions {
            ForEach(actions) { action in
                
                Button(action.title) {
                    Task { @MainActor in
                        await action.action()
                    }
                }
                .tint(tint(for: action.role))
            }
        }
    }
    
    private func tint(for role: EstatiaSwipeAction.Role) -> Color {
        switch role {
        case .normal:
            return .blue
        case .destructive:
            return .red
        }
    }
}
