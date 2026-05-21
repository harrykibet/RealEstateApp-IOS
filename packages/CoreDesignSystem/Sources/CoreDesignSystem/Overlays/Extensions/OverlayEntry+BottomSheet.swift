//
//  OverlayEntry+BottomSheet.swift
//  CoreDesignSystem
//
//  Created by builder on 5/21/26.
//

import SwiftUI

@MainActor
public extension OverlayEntry {

    static func bottomSheet<Content: View>(
        model: BottomSheetModel,
        @ViewBuilder content: () -> Content
    ) -> OverlayEntry {

        OverlayEntry(
            id: model.id,
            priority: .sheet,
            transition: .slideFromBottom,
            environment: OverlayEnvironment(
                allowsBackgroundInteraction: false,
                dismissOnBackgroundTap: true,
                blocksAccessibilityFocus: true,
                ignoresSafeArea: true
            )
        ) {

            ZStack(alignment: .bottom) {

                Color.black.opacity(0.35)
                    .ignoresSafeArea()

                EstatiaBottomSheet(
                    model: model,
                    content: content
                )
            }
            .ignoresSafeArea()
        }
    }
}
