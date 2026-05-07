//
//  OverlayManager.swift
//  CoreDesignSystem
//
//  Created by builder on 5/7/26.
//

import Foundation

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
        overlays.append(entry)
        
        overlays.sort {
            $0.priority < $1.priority
        }
    }
    
    public func dismiss(
        id: OverlayID
    ) {
        overlays.removeAll {
            $0.id == id
        }
    }
    
    public func dismissAll() {
        overlays.removeAll()
    }
    
    public func contains(
        id: OverlayID
    ) -> Bool {
        overlays.contains {
            $0.id == id
        }
    }
}
