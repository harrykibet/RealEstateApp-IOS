//
//  OverlayEntry+Dialog.swift
//  CoreDesignSystem
//
//  Created by builder on 5/21/26.
//

import SwiftUI

public extension OverlayEntry {

    static func dialog(
        model: DialogModel
    ) -> OverlayEntry {

        OverlayEntry(
            id: model.id,
            priority: .dialog,
            transition: .scale,
            environment: OverlayEnvironment(
                allowsBackgroundInteraction: false,
                dismissOnBackgroundTap: false,
                blocksAccessibilityFocus: true,
                ignoresSafeArea: true
            )
        ) {

            ZStack {

                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                EstatiaDialog(model: model)
            }
        }
    }
}
