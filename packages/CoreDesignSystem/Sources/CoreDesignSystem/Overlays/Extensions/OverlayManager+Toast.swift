//
//  OverlayManager+Toast.swift
//  CoreDesignSystem
//
//  Created by builder on 5/21/26.
//

import Foundation

public extension OverlayManager {
    
    @discardableResult
    func showToast(
        _ model: ToastModel
    ) -> OverlayID {
        
        let entry = OverlayEntry.toast(
            model: model
        )
        
        present(entry)
        
        scheduleToastDismissal(
            id: model.id,
            duration: model.duration
        )
        
        return model.id
    }
    
    func scheduleToastDismissal(
        id: OverlayID,
        duration: Duration
    ) {
        
        Task { [weak self] in
            
            try? await Task.sleep(
                for: duration
            )
            
            guard !Task.isCancelled else {
                return
            }
            
            await self?.dismiss(id: id)
        }
    }
}
