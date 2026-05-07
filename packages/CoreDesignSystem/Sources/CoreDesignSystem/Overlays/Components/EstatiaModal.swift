//
//  EstatiaModal.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaModal<Content: View>: View {

    private let model: ModalModel
    private let content: Content

    public init(
        model: ModalModel,
        @ViewBuilder content: () -> Content
    ) {
        self.model = model
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {

            if let title = model.title {
                Text(title)
                    .font(.headline)
                    .padding()
            }

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .padding(16)
    }
}
