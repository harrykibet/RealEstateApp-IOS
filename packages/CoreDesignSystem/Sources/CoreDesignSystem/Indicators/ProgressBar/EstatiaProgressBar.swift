//
//  EstatiaProgressBar.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//


import SwiftUI

public struct EstatiaProgressBar: View {

    private let progress: Double
    private let isIndeterminate: Bool
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let showLabel: Bool
    private let label: String?
    private let tint: Color
    private let background: Color

    @State private var indeterminateOffset: CGFloat = -1

    public init(
        progress: Double,
        isIndeterminate: Bool = false,
        height: CGFloat = 6,
        cornerRadius: CGFloat = 999,
        showLabel: Bool = false,
        label: String? = nil,
        tint: Color = .accentColor,
        background: Color = Color.gray.opacity(0.2)
    ) {
        self.progress = progress
        self.isIndeterminate = isIndeterminate
        self.height = height
        self.cornerRadius = cornerRadius
        self.showLabel = showLabel
        self.label = label
        self.tint = tint
        self.background = background
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            if showLabel, let label {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            GeometryReader { geo in
                let width = geo.size.width

                ZStack(alignment: .leading) {
                    backgroundLayer

                    if isIndeterminate {
                        indeterminateBar(width: width)
                    } else {
                        determinateBar(width: width)
                    }
                }
            }
            .frame(height: height)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(label ?? "Progress")
            .accessibilityValue(accessibilityValue)
        }
        .onAppear {
            if isIndeterminate {
                startIndeterminateAnimation()
            }
        }
    }
}
