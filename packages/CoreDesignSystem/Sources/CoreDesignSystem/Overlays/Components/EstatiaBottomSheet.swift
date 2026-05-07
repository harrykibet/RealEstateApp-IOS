//
//  EstatiaBottomSheet.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaBottomSheet<Content: View>: View {

    @GestureState
    private var dragOffset: CGFloat = 0

    private let model: BottomSheetModel
    private let content: Content

    public init(
        model: BottomSheetModel,
        @ViewBuilder content: () -> Content
    ) {
        self.model = model
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {

            if model.showsGrabber {
                Capsule()
                    .fill(Color.secondary.opacity(0.5))
                    .frame(width: 48, height: 6)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
            }

            content
                .frame(maxWidth: .infinity)
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .offset(y: max(0, dragOffset))
        .gesture(dragGesture)
    }
}

private extension EstatiaBottomSheet {

    var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                guard model.allowsInteractiveDismiss else { return }
                state = max(0, value.translation.height)
            }
    }
}
