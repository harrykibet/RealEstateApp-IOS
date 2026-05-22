//
//  EstatiaDialog.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaDialog: View {

    private let model: DialogModel

    public init(model: DialogModel) {
        self.model = model
    }

    public var body: some View {
        VStack(spacing: 20) {

            VStack(spacing: 8) {

                Text(model.title)
                    .font(.title3.weight(.semibold))

                if let message = model.message {
                    Text(message)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }

            VStack(spacing: 12) {

                ForEach(model.actions) { action in
                    Button(action.title) {
                        action.handler()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: 340)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 24)
        .padding(24)
    }
}

#if DEBUG

private struct EstatiaDialogPreviewContainer: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                // MARK: - Standard
                
                section(title: "Standard Dialog") {
                    EstatiaDialog(
                        model: DialogModel(
                            title: "Delete Property",
                            message: "Are you sure you want to permanently delete this property listing?",
                            actions: [
                                .init(
                                    title: "Cancel",
                                    role: .cancel
                                ) {},
                                
                                .init(
                                    title: "Delete",
                                    role: .destructive
                                ) {}
                            ]
                        )
                    )
                }
                
                // MARK: - Single Action
                
                section(title: "Single Action") {
                    EstatiaDialog(
                        model: DialogModel(
                            title: "Session Expired",
                            message: "Please sign in again to continue.",
                            actions: [
                                .init(
                                    title: "OK"
                                ) {}
                            ]
                        )
                    )
                }
                
                // MARK: - Stress
                
                section(title: "Long Content Stress Test") {
                    EstatiaDialog(
                        model: DialogModel(
                            title: "Extremely Long Dialog Title For Validation Testing",
                            message: """
                            This dialog intentionally contains long multiline text \
                            to validate wrapping behavior, intrinsic sizing, \
                            spacing consistency, and accessibility scaling support.
                            """,
                            actions: [
                                .init(title: "Dismiss") {}
                            ]
                        )
                    )
                }
            }
            .padding()
        }
    }
    
    // MARK: - Section
    
    @ViewBuilder
    private func section(
        title: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            content()
        }
    }
}

// MARK: - Previews

#Preview("Dialog - Light") {
    Preview.light {
        EstatiaDialogPreviewContainer()
    }
}

#Preview("Dialog - Dark") {
    Preview.dark {
        EstatiaDialogPreviewContainer()
    }
}

#endif
