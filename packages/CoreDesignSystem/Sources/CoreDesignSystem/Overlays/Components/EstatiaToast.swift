//
//  EstatiaToast.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaToast: View {

    private let model: ToastModel

    public init(model: ToastModel) {
        self.model = model
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {

            indicator

            VStack(alignment: .leading, spacing: 4) {
                Text(model.title)
                    .font(.headline)

                if let message = model.message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 12)
        .padding(.horizontal, 16)
    }
}

private extension EstatiaToast {

    var indicator: some View {
        Circle()
            .fill(indicatorColor)
            .frame(width: 10, height: 10)
            .padding(.top, 6)
    }

    var backgroundColor: Color {
        switch model.style {
        case .info: return Color.blue.opacity(0.15)
        case .success: return Color.green.opacity(0.15)
        case .warning: return Color.orange.opacity(0.15)
        case .error: return Color.red.opacity(0.15)
        }
    }

    var indicatorColor: Color {
        switch model.style {
        case .info: return .blue
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        }
    }
}
