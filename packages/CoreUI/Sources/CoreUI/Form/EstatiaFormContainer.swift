//
//  FormContainer.swift
//  CoreUI
//
//  Created by builder on 4/9/26.
//

import SwiftUI
import CoreDesignSystem

public struct EstatiaFormContainer<Content: View>: View {
    
    private let isSubmitting: Bool
    private let onSubmit: () -> Void
    private let content: Content
    
    public init(
        isSubmitting: Bool,
        onSubmit: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.isSubmitting = isSubmitting
        self.onSubmit = onSubmit
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            
            content
            
            EstatiaPrimaryButton(
                title: isSubmitting ? "Submitting..." : "Submit",
                isLoading: isSubmitting,
                action: onSubmit
            )
        }
        .disabled(isSubmitting)
    }
}
