//
//  OverlayHost.swift
//  CoreDesignSystem
//
//  Created by builder on 5/7/26.
//

import SwiftUI

struct OverlayHost: View {
    
    let entry: OverlayEntry
    
    var body: some View {
        entry.content
            .transition(transition)
            .zIndex(Double(entry.priority.rawValue))
    }
}

private extension OverlayHost {
    
    var transition: AnyTransition {
        
        switch entry.transition {
            
        case .opacity:
            return .opacity
            
        case .scale:
            return .scale
            
        case .slideFromBottom:
            return .move(edge: .bottom)
            
        case .slideFromTop:
            return .move(edge: .top)
            
        case .slideFromLeading:
            return .move(edge: .leading)
            
        case .slideFromTrailing:
            return .move(edge: .trailing)
            
        case let .custom(insertion, removal):
            return .asymmetric(
                insertion: transition(from: insertion),
                removal: transition(from: removal)
            )
        }
    }
    
    func transition(
        from value: String
    ) -> AnyTransition {
        
        switch value {
            
        case "opacity":
            return .opacity
            
        case "scale":
            return .scale
            
        default:
            return .identity
        }
    }
}
