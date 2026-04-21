//
//  EstatiaCircularProgress.swift
//  CoreDesignSystem
//
//  Created by builder on 4/20/26.
//


import SwiftUI

public struct EstatiaCircularProgress: View {

    @Environment(\.theme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let state: EstatiaProgressState
    private let style: EstatiaProgressStyle
    private let size: CGFloat
    private let lineWidth: CGFloat

    @State private var rotation: Double = 0

    public init(
        state: EstatiaProgressState,
        style: EstatiaProgressStyle = .primary,
        size: CGFloat = 40,
        lineWidth: CGFloat = 4
    ) {
        self.state = state
        self.style = style
        self.size = size
        self.lineWidth = lineWidth
    }

    public var body: some View {
        ZStack {
            backgroundCircle

            switch state {
            case .idle:
                EmptyView()

            case .indeterminate:
                indeterminateCircle

            case .determinate(let value):
                determinateCircle(progress: value)

            case .buffered(let value, _):
                determinateCircle(progress: value)

            case .success:
                determinateCircle(progress: 1.0)

            case .error:
                determinateCircle(progress: 1.0)
            }
        }
        .frame(width: size, height: size)
        .onAppear { startAnimationIfNeeded() }
        .onChange(of: state) { _, _ in startAnimationIfNeeded() }
    }
}

public extension EstatiaCircularProgress {
    
    private var backgroundCircle: some View {
        Circle()
            .stroke(theme.colors.progressBackground, lineWidth: lineWidth)
    }
    
    private var progressAnimation: Animation? {
        reduceMotion ? nil : .easeInOut(duration: 0.25)
    }
    
    private func determinateCircle(progress: Double) -> some View {
        Circle()
            .trim(from: 0, to: clamp(progress))
            .stroke(
                fillColor,
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(-90))
            .animation(progressAnimation, value: progress)
    }
    
    private var indeterminateCircle: some View {
        Circle()
            .trim(from: 0.2, to: 0.8)
            .stroke(
                fillColor,
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(rotation))
    }
    
    private func startAnimationIfNeeded() {
        guard case .indeterminate = state else {
            rotation = 0
            return
        }
        
        guard !reduceMotion else { return }
        
        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
            rotation = 360
        }
    }
    
    private var fillColor: Color {
        switch state {
        case .error:
            return theme.colors.error
        case .success:
            return theme.colors.success
        default:
            return theme.colors.progressFill(for: style)
        }
    }
    
    private func clamp(_ value: Double) -> Double {
        min(max(value, 0), 1)
    }
}
