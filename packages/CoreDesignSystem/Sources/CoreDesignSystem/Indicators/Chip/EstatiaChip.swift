//
//  EstatiaChip.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//

import SwiftUI


public struct EstatiaChip: View {

    private let content: EstatiaChipContent
    private let style: EstatiaChipStyle
    private let size: EstatiaChipSize
    private let mode: EstatiaChipMode

    @Environment(\.theme) private var theme

    public init(
        content: EstatiaChipContent,
        style: EstatiaChipStyle = .filled,
        size: EstatiaChipSize = .medium,
        mode: EstatiaChipMode
    ) {
        self.content = content
        self.style = style
        self.size = size
        self.mode = mode
    }

    public var body: some View {
        HStack(spacing: 6) {
            
            if let leading = content.leadingIcon {
                Image(systemName: leading)
            }
            
            Text(content.title)
            
            if let trailing = trailingIcon {
                Image(systemName: trailing)
            }
        }
        .font(font)
        .padding(padding)
        .background(background)
        .overlay(border)
        .clipShape(Capsule())
        .contentShape(Capsule())
        .onTapGesture(perform: handleTap)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(accessibilityTraits)
    }
}

// MARK: - Derived State

private extension EstatiaChip {

    var isSelected: Bool {
        if case let .selectable(selected, _) = mode {
            return selected
        }
        return false
    }

    var trailingIcon: String? {
        switch mode {
        case .removable:
            return "xmark"
        default:
            return content.trailingIcon
        }
    }
}

// MARK: - Interaction Handling

private extension EstatiaChip {

    func handleTap() {
        switch mode {
        case .action(let action):
            action()
            
        case .selectable(let selected, let toggle):
            toggle(!selected)
            
        case .removable(let remove):
            remove()
        }
    }
}

// MARK: - Styling System

private extension EstatiaChip {

    var background: some View {
        Group {
            if style == .filled {
                (isSelected ? theme.colors.primary : theme.colors.surfaceVariant)
            } else {
                Color.clear
            }
        }
    }

    var border: some View {
        Capsule()
            .stroke(
                isSelected
                ? theme.colors.primary
                : theme.colors.outline,
                lineWidth: 1
            )
    }

    var foreground: Color {
        if isSelected {
            return theme.colors.onPrimary
        }
        return theme.colors.onSurface
    }
}

// MARK: - Layout System

private extension EstatiaChip {

    var padding: EdgeInsets {
        switch size {
        case .small:
            return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        case .medium:
            return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        }
    }

    var font: Font {
        switch size {
        case .small:
            return theme.typography.caption
        case .medium:
            return theme.typography.footnote
        }
    }
}

// MARK: - Accesibility

private extension EstatiaChip {

    var accessibilityLabel: String {
        switch mode {
        case .selectable(let selected, _):
            return "\(content.title), \(selected ? "selected" : "not selected")"
            
        case .removable:
            return "\(content.title), removable"
            
        case .action:
            return content.title
        }
    }

    var accessibilityTraits: AccessibilityTraits {
        switch mode {
        case .selectable:
            return [.isButton, isSelected ? .isSelected : []]
        case .removable:
            return .isButton
        case .action:
            return .isButton
        }
    }
}
