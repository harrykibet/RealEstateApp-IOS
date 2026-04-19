//
//  EstatiaProgressBar.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//


import SwiftUI

public struct EstatiaProgressBar: View {

    @Environment(\.theme) private var theme

    private let progress: Double
    private let isIndeterminate: Bool
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let showLabel: Bool
    private let label: String?

    @State private var indeterminateOffset: CGFloat = -1

    public init(
        progress: Double,
        isIndeterminate: Bool = false,
        height: CGFloat = 6,
        cornerRadius: CGFloat = 999,
        showLabel: Bool = false,
        label: String? = nil
    ) {
        self.progress = progress
        self.isIndeterminate = isIndeterminate
        self.height = height
        self.cornerRadius = cornerRadius
        self.showLabel = showLabel
        self.label = label
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
            .accessibilityValue(accessibilityValue)
        }
        .onAppear {
            if isIndeterminate {
                startIndeterminateAnimation()
            }
        }
    }
}

// MARK: - Background Layer

private extension EstatiaProgressBar {
    var backgroundLayer: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(theme.colors.progressBackground)
    }
}

// MARK: - Determinate Mode

private extension EstatiaProgressBar {
    func determinateBar(width: CGFloat) -> some View {
        let clamped = min(max(progress, 0), 1)

        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(theme.colors.progressFill)
            .frame(width: width * clamped)
            .animation(.easeInOut(duration: 0.25), value: clamped)
    }
}

// MARK: - Indeterminate Mode

private extension EstatiaProgressBar {
    func indeterminateBar(width: CGFloat) -> some View {
        let barWidth = width * 0.35

        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(theme.colors.progressFill)
            .frame(width: barWidth)
            .offset(x: indeterminateOffset * width)
    }
}

// MARK: - Accessibility

private var accessibilityValue: String {
    if isIndeterminate {
        return "Loading"
    }

    let percent = Int((min(max(progress, 0), 1)) * 100)
    return "\(percent) percent"
}
