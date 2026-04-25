//
//  EstatiaRadioButton.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaRadioButton<Value: Hashable>: View {
    
    // MARK: - Properties
    
    @Binding private var selection: Value
    private let value: Value
    private let title: String?
    private let isEnabled: Bool
    
    @Environment(\.theme) private var theme
    
    // MARK: - Init
    
    public init(
        selection: Binding<Value>,
        value: Value,
        title: String? = nil,
        isEnabled: Bool = true
    ) {
        self._selection = selection
        self.value = value
        self.title = title
        self.isEnabled = isEnabled
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: select) {
            HStack(spacing: 12) {
                radioCircle
                if let title {
                    EstatiaText(title)
                        .foregroundColor(foregroundColor)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
    
    // MARK: - Components
    
    private var radioCircle: some View {
        ZStack {
            Circle()
                .stroke(borderColor, lineWidth: 2)
                .frame(width: 20, height: 20)
            
            if isSelected {
                Circle()
                    .fill(theme.colors.primary)
                    .frame(width: 10, height: 10)
            }
        }
    }
    
    // MARK: - State
    
    private var isSelected: Bool {
        selection == value
    }
    
    private var borderColor: Color {
        isSelected ? theme.colors.primary : theme.colors.outline
    }
    
    private var foregroundColor: Color {
        isEnabled ? theme.colors.onSurface : theme.colors.disabled
    }
    
    // MARK: - Actions
    
    private func select() {
        guard isEnabled else { return }
        selection = value
    }
}

#if DEBUG

private struct EstatiaRadioButtonPreviewContent: View {
    
    @State private var selection = "A"
    
    var body: some View {
        VStack(spacing: 16) {
            
            EstatiaRadioButton(
                selection: $selection,
                value: "A",
                title: "Option A"
            )
            
            EstatiaRadioButton(
                selection: $selection,
                value: "B",
                title: "Option B"
            )
        }
    }
}

#Preview("Radio - Light") {
    Preview.light {
        Preview.padded {
            EstatiaRadioButtonPreviewContent()
        }
    }
}

#Preview("Radio - Dark") {
    Preview.dark {
        Preview.padded {
            EstatiaRadioButtonPreviewContent()
        }
    }
}

#endif
