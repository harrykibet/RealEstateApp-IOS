//
//  OverlayManager.swift
//  CoreDesignSystem
//
//  Created by builder on 5/7/26.
//

import SwiftUI

@MainActor
public final class OverlayManager:
    ObservableObject
{
    
    @Published
    public private(set) var overlays: [OverlayEntry] = []
    
    public init() {}
    
    public func present(
        _ entry: OverlayEntry
    ) {
        withAnimation(
            .spring(
                response: 0.35,
                dampingFraction: 0.85
            )
        ) {
            overlays.append(entry)
            
            overlays.sort {
                
                if $0.priority == $1.priority {
                    return $0.id.rawValue.uuidString <
                           $1.id.rawValue.uuidString
                }
                
                return $0.priority < $1.priority
            }
        }
    }
    
    public func dismiss(
        id: OverlayID
    ) {
        withAnimation(
            .spring(
                response: 0.35,
                dampingFraction: 0.85
            )
        ) {
            overlays.removeAll {
                $0.id == id
            }
        }
    }
    
    public func dismissAll() {
        withAnimation(
            .spring(
                response: 0.35,
                dampingFraction: 0.85
            )
        ) {
            overlays.removeAll()
        }
    }
}
