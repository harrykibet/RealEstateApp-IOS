//
//  EstatiaBadge 2.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//


import SwiftUI

public struct EstatiaBadge: View {
    
    private let content: EstatiaBadgeContent
    private let style: EstatiaBadgeStyle
    private let size: EstatiaBadgeSize
    
    public var isDecorative: Bool = false
    
    private let accessibilityOverride: String?
    
    @Environment(\.theme) private var theme
    
    public init(
        content: EstatiaBadgeContent,
        style: EstatiaBadgeStyle = .primary,
        size: EstatiaBadgeSize = .medium,
        accessibilityLabel: String? = nil
    ) {
        self.content = content
        self.style = style
        self.size = size
        self.accessibilityOverride = accessibilityLabel
    }
    
    public var body: some View {
        contentView
            .font(font)
            .foregroundColor(foregroundColor)
            .padding(padding)
            .background(backgroundColor)
            .clipShape(Capsule())
            .fixedSize()
            .dynamicTypeSize(...DynamicTypeSize.large)
            .minimumScaleFactor(0.8)
        
            // Accessibility
            .accessibilityElement(children: .ignore)
            .accessibilityHidden(isDecorative)
            .accessibilityLabel(accessibilityOverride ?? accessibilityLabelText)
            .accessibilityAddTraits(.isStaticText)
    }
}

 // MARK: - Subviews

private extension EstatiaBadge {

    @ViewBuilder
    var contentView: some View {
        switch content {
        case .text(let value):
            Text(value)

        case .count(let count):
            Text(formattedCount(count))

        case .icon(let systemName):
            Image(systemName: systemName)
        }
    }
}

// MARK: - Count Formatting

private extension EstatiaBadge {

    func formattedCount(_ count: Int) -> String {
        switch count {
        case 0...99:
            return "\(count)"
        case 100...999:
            return "99+"
        default:
            return "999+"
        }
    }
}

// MARK: - Styling System

private extension EstatiaBadge {

    var backgroundColor: Color {
        switch style {
        case .primary: return theme.colors.primary
        case .secondary: return theme.colors.surfaceVariant
        case .success: return theme.colors.success
        case .warning: return theme.colors.warning
        case .error: return theme.colors.error
        case .neutral: return theme.colors.outline
        }
    }

    var foregroundColor: Color {
        switch style {
        case .primary, .success, .error:
            return theme.colors.onPrimary

        case .secondary, .neutral:
            return theme.colors.onSurface

        case .warning:
            return theme.colors.warning
        }
    }
}

 // MARK: - Size System

private extension EstatiaBadge {

    var padding: EdgeInsets {
        switch size {
        case .small:
            return EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)

        case .medium:
            return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)

        case .large:
            return EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
        }
    }

    var font: Font {
        switch size {
        case .small:
            return theme.typography.caption
        case .medium:
            return theme.typography.label
        case .large:
            return theme.typography.body
        }
    }
}

private extension EstatiaBadge {

    var accessibilityLabelText: String {
        switch content {
        case .text(let value):
            return value

        case .count(let count):
            return "\(count) items"

        case .icon(let systemName):
            return iconAccessibilityDescription(systemName)
        }
    }

    func iconAccessibilityDescription(_ systemName: String) -> String {
        switch systemName {
        case "star.fill": return "Favorite"
        case "checkmark.seal.fill": return "Verified"
        default: return "Badge"
        }
    }
}
