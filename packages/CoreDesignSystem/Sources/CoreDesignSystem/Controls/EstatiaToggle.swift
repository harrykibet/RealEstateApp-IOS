import SwiftUI

public struct EstatiaToggle: View {
    
    // MARK: - State
    
    @Binding private var isOn: Bool
    private let state: ToggleState
    private let onChanged: ((Bool) -> Void)?
    
    @Environment(\.theme) private var theme
    
    // MARK: - Gesture
    
    @GestureState private var dragOffset: CGFloat = 0
    
    // MARK: - Init
    
    public init(
        isOn: Binding<Bool>,
        state: ToggleState = .normal,
        onChanged: ((Bool) -> Void)? = nil
    ) {
        self._isOn = isOn
        self.state = state
        self.onChanged = onChanged
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let thumbSize: CGFloat = height - 4
            
            ZStack(alignment: .leading) {
                
                track
                
                thumb
                    .offset(x: thumbOffset(width: width, thumbSize: thumbSize))
            }
            .frame(height: height)
            .contentShape(Rectangle())
            .gesture(dragGesture(width: width))
            .onTapGesture {
                toggle()
            }
        }
        .frame(width: 52, height: height)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}

// MARK: - Layout

private extension EstatiaToggle {
    
    var height: CGFloat { 32 }
    
    func thumbOffset(width: CGFloat, thumbSize: CGFloat) -> CGFloat {
        let base = isOn ? (width - thumbSize - 2) : 2
        return base + dragOffset
    }
}

// MARK: - Subviews

private extension EstatiaToggle {
    
    var track: some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(trackColor)
    }
    
    var thumb: some View {
        Circle()
            .fill(theme.colors.surface)
            .frame(width: height - 4, height: height - 4)
            .shadow(radius: 1)
    }
}

// MARK: - Styling

private extension EstatiaToggle {
    
    var isDisabled: Bool {
        if case .disabled = state { return true }
        return false
    }
    
    var trackColor: Color {
        isOn ? theme.colors.primary : theme.colors.surfaceVariant
    }
}

// MARK: - Gestures

private extension EstatiaToggle {
    
    func dragGesture(width: CGFloat) -> some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                guard !isDisabled else { return }
                
                let translation = value.translation.width
                state = clampDrag(translation, width: width)
            }
            .onEnded { value in
                guard !isDisabled else { return }
                
                let threshold = width / 2
                let shouldTurnOn = value.location.x > threshold
                
                setState(shouldTurnOn)
            }
    }
    
    func clampDrag(_ translation: CGFloat, width: CGFloat) -> CGFloat {
        let maxOffset = width - height
        return min(max(translation, -maxOffset), maxOffset)
    }
}

// MARK: - Actions

private extension EstatiaToggle {
    
    func toggle() {
        guard !isDisabled else { return }
        
        setState(!isOn)
    }
    
    func setState(_ newValue: Bool) {
        withAnimation(.easeInOut(duration: 0.2)) {
            isOn = newValue
        }
        onChanged?(newValue)
    }
}


#if DEBUG

private struct EstatiaTogglePreviewContent: View {
    
    @State private var isOn1 = true
    @State private var isOn2 = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            EstatiaToggle(
                isOn: $isOn1
            )
            
            EstatiaToggle(
                isOn: $isOn2
            )
        }
    }
}

#Preview("Toggle - Light") {
    Preview.light {
        Preview.padded {
            EstatiaTogglePreviewContent()
        }
    }
}

#Preview("Toggle - Dark") {
    Preview.dark {
        Preview.padded {
            EstatiaTogglePreviewContent()
        }
    }
}

#endif
