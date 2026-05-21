//
//  OverlayEntry+Modal.swift
//  CoreDesignSystem
//
//  Created by builder on 5/21/26.
//

import SwiftUI

public extension OverlayEntry {

    static func modal<Content: View>(
        model: ModalModel,
        @ViewBuilder content: () -> Content
    ) -> OverlayEntry {

        OverlayEntry(
            id: model.id,
            priority: .modal,
            transition: .slideFromBottom,
            environment: OverlayEnvironment(
                allowsBackgroundInteraction: false,
                dismissOnBackgroundTap: model.dismissOnBackgroundTap,
                blocksAccessibilityFocus: true,
                ignoresSafeArea: true
            )
        ) {

            ZStack {

                Color.black.opacity(0.35)
                    .ignoresSafeArea()

                EstatiaModal(
                    model: model,
                    content: content
                )
            }
        }
    }
}
