//
//  OverlayManager+BottomSheet.swift
//  CoreDesignSystem
//
//  Created by builder on 5/21/26.
//

import SwiftUI

public extension OverlayManager {

    @discardableResult
    func showBottomSheet<Content: View>(
        model: BottomSheetModel,
        @ViewBuilder content: () -> Content
    ) -> OverlayID {

        let entry = OverlayEntry.bottomSheet(
            model: model,
            content: content
        )

        present(entry)

        return model.id
    }
}
