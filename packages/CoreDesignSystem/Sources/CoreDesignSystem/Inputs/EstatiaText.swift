//
//  EstatiaText.swift
//  CoreDesignSystem
//
//  Created by builder on 4/25/26.
//


import SwiftUI

public struct EstatiaText: View {
    
    private let content: String
    private let style: EstatiaTextStyle
    private let color: Color?
    
    @Environment(\.theme) private var theme
    
    public init(
        _ content: String,
        style: EstatiaTextStyle = .body,
        color: Color? = nil
    ) {
        self.content = content
        self.style = style
        self.color = color
    }
    
    public var body: some View {
        Text(content)
            .font(font)
            .foregroundColor(color ?? theme.colors.textPrimary)
    }
}

// MARK: - Mapping

private extension EstatiaText {
    
    var font: Font {
        switch style {
        case .display: return theme.typography.display
        case .title:   return theme.typography.title
        case .body:    return theme.typography.body
        case .label:   return theme.typography.label
        case .caption: return theme.typography.caption
        case .button:  return theme.typography.button
        }
    }
}
