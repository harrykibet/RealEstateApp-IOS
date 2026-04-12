//
//  EstatiaCheckbox.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaCheckbox: View {
    
    // MARK: - State
    
    @Binding private var isChecked: Bool
    private let label: String?
    private let state: CheckboxState
    private let onChanged: ((Bool) -> Void)?
    
    @Environment(\.theme) private var theme
    
    // MARK: - Init
    
    public init(
        isChecked: Binding<Bool>,
        label: String? = nil,
        state: CheckboxState = .normal,
        onChanged: ((Bool) -> Void)? = nil
    ) {
        self._isChecked = isChecked
        self.label = label
        self.state = state
        self.onChanged = onChanged
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 12) {
            
            checkbox
            
            if let label {
                Text(label)
                    .foregroundColor(labelColor)
            }
        }
        .contentShape(Rectangle()) // Expand tab area
        .gesture(
            TapGesture().onEnded {
                toggle()
            }
        )
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}

// MARK: - Subviews

private extension EstatiaCheckbox {
    
    var checkbox: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .stroke(borderColor, lineWidth: 2)
                .background(background)
                .frame(width: 22, height: 22)
            
            if isChecked {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(checkmarkColor)
            }
        }
    }
}

// MARK: - Styling

private extension EstatiaCheckbox {
    
    var isDisabled: Bool {
        if case .disabled = state { return true }
        return false
    }
    
    var borderColor: Color {
        switch state {
        case .error:
            return theme.colors.error
        case .disabled:
            return theme.colors.surfaceVariant
        default:
            return isChecked ? theme.colors.primary : theme.colors.surfaceVariant
        }
    }
    
    var background: some View {
        Group {
            if isChecked {
                theme.colors.primary
            }
            else {
                theme.colors.surface
            }
        }
    }
    
    var checkmarkColor: Color {
        theme.colors.onPrimary
    }
    
    var labelColor: Color {
        isDisabled ? theme.colors.textDisabled : theme.colors.textPrimary
    }
}

// MARK: - Actions

private extension EstatiaCheckbox {
    
    func toggle() {
        guard !isDisabled else { return }
        
        withAnimation(.easeInOut(duration: 0.15)) {
            isChecked.toggle()
        }
        onChanged?(isChecked)
    }
}

#if DEBUG

private struct CheckboxPreviewContent: View {
    
    @State private var checked1 = false
    @State private var checked2 = true
    @State private var checked3 = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            EstatiaCheckbox(
                isChecked: $checked1,
                label: "Accept Terms"
            )
            
            EstatiaCheckbox(
                isChecked: $checked2,
                label: "Subscribe to newsletter"
            )
            
            EstatiaCheckbox(
                isChecked: $checked3,
                label: "Disabled",
                state: .disabled
            )
            
            EstatiaCheckbox(
                isChecked: .constant(true),
                label: "Error state",
                state: .error
            )
        }
    }
}

#Preview("Checkbox - Light") {
    Preview.light {
        Preview.states {
            CheckboxPreviewContent()
        }
    }
}

#Preview("Checkbox - Dark") {
    Preview.dark {
        Preview.states {
            CheckboxPreviewContent()
        }
    }
}

#endif
