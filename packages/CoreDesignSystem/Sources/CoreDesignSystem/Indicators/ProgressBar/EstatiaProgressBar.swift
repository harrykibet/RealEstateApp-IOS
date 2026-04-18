//
//  EstatiaProgressBar.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//


public struct EstatiaProgressBar: View {
    public init(
        progress: Double,
        isIndeterminate: Bool = false,
        height: CGFloat = 6,
        cornerRadius: CGFloat = 999,
        showLabel: Bool = false,
        label: String? = nil,
        tint: Color = .accentColor,
        background: Color = Color.gray.opacity(0.2)
    )
}