//
//  OverlayManager+Dialog.swift
//  CoreDesignSystem
//
//  Created by builder on 5/21/26.
//

import Foundation

public extension OverlayManager {

    @discardableResult
    func showDialog(
        _ model: DialogModel
    ) -> OverlayID {

        let entry = OverlayEntry.dialog(
            model: model
        )

        present(entry)

        return model.id
    }
}
