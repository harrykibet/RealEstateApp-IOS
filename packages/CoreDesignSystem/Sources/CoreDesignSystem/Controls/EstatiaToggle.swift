//
//  EstatiaToggle.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

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
        self.isOn = isOn
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
        }
    }
}
