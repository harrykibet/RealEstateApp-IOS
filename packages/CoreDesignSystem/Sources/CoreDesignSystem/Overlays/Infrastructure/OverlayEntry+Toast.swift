//
//  OverlayEntry+Toast.swift
//  CoreDesignSystem
//
//  Created by builder on 5/21/26.
//

import SwiftUI

public extension OverlayEntry {

    static func toast(
        model: ToastModel
    ) -> OverlayEntry {

        OverlayEntry(
            id: model.id,
            priority: .toast,
            transition: .slideFromTop,
            environment: OverlayEnvironment(
                allowsBackgroundInteraction: true,
                dismissOnBackgroundTap: false,
                blocksAccessibilityFocus: false,
                ignoresSafeArea: false
            )
        ) {

            VStack {
                EstatiaToast(model: model)

                Spacer()
            }
            .padding(.top, 16)
        }
    }
}
