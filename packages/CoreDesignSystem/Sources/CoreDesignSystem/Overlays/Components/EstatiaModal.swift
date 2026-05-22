//
//  EstatiaModal.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaModal<Content: View>: View {

    private let model: ModalModel
    private let content: Content

    public init(
        model: ModalModel,
        @ViewBuilder content: () -> Content
    ) {
        self.model = model
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {

            if let title = model.title {
                Text(title)
                    .font(.headline)
                    .padding()
            }

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .padding(16)
    }
}

#if DEBUG

private struct EstatiaModalPreviewContainer: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                // MARK: - Standard
                
                section(title: "Standard Modal") {
                    EstatiaModal(
                        model: ModalModel(
                            title: "Property Details"
                        )
                    ) {
                        
                        VStack(spacing: 16) {
                            Text("Modern Apartment")
                            
                            Text("Kilimani, Nairobi")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                    }
                    .frame(height: 240)
                }
                
                // MARK: - Large Content
                
                section(title: "Large Content Stress Test") {
                    EstatiaModal(
                        model: ModalModel(
                            title: "Large Modal"
                        )
                    ) {
                        
                        ScrollView {
                            VStack(spacing: 12) {
                                
                                ForEach(0..<20) { index in
                                    Text("Modal Item \(index)")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 12)
                                        )
                                }
                            }
                            .padding()
                        }
                    }
                    .frame(height: 500)
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

#Preview("Modal - Light") {
    Preview.light {
        EstatiaModalPreviewContainer()
    }
}

#Preview("Modal - Dark") {
    Preview.dark {
        EstatiaModalPreviewContainer()
    }
}

#endif
