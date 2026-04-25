//
//  EstatiaProgressBar.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//

import SwiftUI

public struct EstatiaProgressBar: View {

    @Environment(\.theme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let state: EstatiaProgressState
    private let style: EstatiaProgressStyle
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let label: String?

    @State private var indeterminateOffset: CGFloat = -1

    public init(
        state: EstatiaProgressState,
        style: EstatiaProgressStyle = .primary,
        height: CGFloat = 6,
        cornerRadius: CGFloat = 999,
        label: String? = nil
    ) {
        self.state = state
        self.style = style
        self.height = height
        self.cornerRadius = cornerRadius
        self.label = label
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            if let label {
                EstatiaText(label, style: .caption)
                    .foregroundStyle(.secondary)
            }

            GeometryReader { geo in
                let width = geo.size.width

                ZStack(alignment: .leading) {
                    backgroundLayer

                    switch state {
                    case .idle:
                        EmptyView()

                    case .indeterminate:
                        indeterminateBar(width: width)

                    case .determinate(let value):
                        determinateBar(width: width, progress: value)

                    case .buffered(let value, let buffer):
                        bufferedBar(width: width, progress: value, buffer: buffer)

                    case .success:
                        determinateBar(width: width, progress: 1.0)

                    case .error:
                        determinateBar(width: width, progress: 1.0)
                    }
                }
            }
            .frame(height: height)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(label ?? "Progress"))
            .accessibilityValue(Text(accessibilityValue))
        }
        .onAppear { updateAnimation() }
        .onChange(of: state) { _, _ in updateAnimation() }
    }
}

// MARK: - Background

private extension EstatiaProgressBar {
    var backgroundLayer: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(theme.colors.progressBackground)
    }
}

// MARK: - Determinate

private extension EstatiaProgressBar {
    func determinateBar(width: CGFloat, progress: Double) -> some View {
        let clamped = clamp(progress)

        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(fillColor)
            .frame(width: width * clamped)
            .animation(animation, value: clamped)
    }
}

// MARK: - Buffered

private extension EstatiaProgressBar {
    func bufferedBar(width: CGFloat, progress: Double, buffer: Double) -> some View {

        let progressClamped = clamp(progress)
        let bufferClamped = clamp(buffer)

        return ZStack(alignment: .leading) {

            // buffer layer
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(fillColor.opacity(0.3))
                .frame(width: width * bufferClamped)

            // actual progress
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(fillColor)
                .frame(width: width * progressClamped)
        }
        .animation(animation, value: progressClamped)
    }
}
// MARK: - Indeterminate

private extension EstatiaProgressBar {
    func indeterminateBar(width: CGFloat) -> some View {
        let barWidth = width * 0.35

        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(fillColor)
            .frame(width: barWidth)
            .offset(x: indeterminateOffset * width)
    }
}

// MARK: - Animation

private extension EstatiaProgressBar {

    func updateAnimation() {
        guard case .indeterminate = state else {
            indeterminateOffset = -1
            return
        }

        guard !reduceMotion else { return }

        indeterminateOffset = -1

        withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) {
            indeterminateOffset = 1.2
        }
    }

    var animation: Animation? {
        reduceMotion ? nil : .easeInOut(duration: 0.25)
    }
}

// MARK: - Style

private extension EstatiaProgressBar {

    var fillColor: Color {
        switch state {
        case .error:
            return theme.colors.error
        case .success:
            return theme.colors.success
        default:
            return theme.colors.progressFill(for: style)
        }
    }
}

// MARK: - Accessibility

private extension EstatiaProgressBar {

    var accessibilityValue: String {
        switch state {
        case .idle:
            return "Idle"
        case .indeterminate:
            return "Loading"
        case .determinate(let value):
            return "\(Int(clamp(value) * 100)) percent"
        case .buffered(let value, _):
            return "\(Int(clamp(value) * 100)) percent"
        case .success:
            return "Completed"
        case .error:
            return "Failed"
        }
    }
}

// MARK: - Helpers

private extension EstatiaProgressBar {
    func clamp(_ value: Double) -> Double {
        min(max(value, 0), 1)
    }
}
