//
//  EstatiaToast.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaToast: View {

    private let model: ToastModel

    public init(model: ToastModel) {
        self.model = model
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {

            indicator

            VStack(alignment: .leading, spacing: 4) {
                Text(model.title)
                    .font(.headline)

                if let message = model.message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 12)
        .padding(.horizontal, 16)
    }
}

private extension EstatiaToast {

    var indicator: some View {
        Circle()
            .fill(indicatorColor)
            .frame(width: 10, height: 10)
            .padding(.top, 6)
    }

    var backgroundColor: Color {
        switch model.style {
        case .info: return Color.blue.opacity(0.15)
        case .success: return Color.green.opacity(0.15)
        case .warning: return Color.orange.opacity(0.15)
        case .error: return Color.red.opacity(0.15)
        }
    }

    var indicatorColor: Color {
        switch model.style {
        case .info: return .blue
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        }
    }
}

#if DEBUG

private struct EstatiaToastPreviewContainer: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Info
                
                section(title: "Info Toast") {
                    EstatiaToast(
                        model: ToastModel(
                            title: "Information",
                            message: "This is an informational toast.",
                            style: .info
                        )
                    )
                }
                
                // MARK: - Success
                
                section(title: "Success Toast") {
                    EstatiaToast(
                        model: ToastModel(
                            title: "Success",
                            message: "Property uploaded successfully.",
                            style: .success
                        )
                    )
                }
                
                // MARK: - Warning
                
                section(title: "Warning Toast") {
                    EstatiaToast(
                        model: ToastModel(
                            title: "Network Warning",
                            message: "Your internet connection is unstable.",
                            style: .warning
                        )
                    )
                }
                
                // MARK: - Error
                
                section(title: "Error Toast") {
                    EstatiaToast(
                        model: ToastModel(
                            title: "Upload Failed",
                            message: "An unexpected server error occurred.",
                            style: .error
                        )
                    )
                }
                
                // MARK: - Layout Stress
                
                section(title: "Long Content Stress Test") {
                    EstatiaToast(
                        model: ToastModel(
                            title: "Very Long Toast Title For Layout Validation",
                            message: """
                            This toast intentionally contains a very long message \
                            to validate multiline layout behavior, spacing stability, \
                            and clipping resistance across dynamic type sizes.
                            """,
                            style: .info
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

#Preview("Toast - Light") {
    Preview.light {
        EstatiaToastPreviewContainer()
    }
}

#Preview("Toast - Dark") {
    Preview.dark {
        EstatiaToastPreviewContainer()
    }
}

#endif
