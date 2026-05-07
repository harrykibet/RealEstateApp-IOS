//
//  EstatiaDialog.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaDialog: View {

    private let model: DialogModel

    public init(model: DialogModel) {
        self.model = model
    }

    public var body: some View {
        VStack(spacing: 20) {

            VStack(spacing: 8) {

                Text(model.title)
                    .font(.title3.weight(.semibold))

                if let message = model.message {
                    Text(message)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }

            VStack(spacing: 12) {

                ForEach(model.actions) { action in
                    Button(action.title) {
                        action.handler()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: 340)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 24)
        .padding(24)
    }
}
