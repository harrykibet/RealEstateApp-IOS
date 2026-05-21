//
//  OverlayManager+Modal.swift
//  CoreDesignSystem
//
//  Created by builder on 5/21/26.
//

import SwiftUI

public extension OverlayManager {

    @discardableResult
    func showModal<Content: View>(
        model: ModalModel,
        @ViewBuilder content: () -> Content
    ) -> OverlayID {

        let entry = OverlayEntry.modal(
            model: model,
            content: content
        )

        present(entry)

        return model.id
    }
}
