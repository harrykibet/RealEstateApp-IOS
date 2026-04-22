//
//  EstatiaSwipeAction.swift
//  CoreDesignSystem
//
//  Created by builder on 4/22/26.
//


public struct EstatiaSwipeAction: Sendable {
    
    public let title: String
    public let role: Role
    public let action: () -> Void
    
    public enum Role {
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
