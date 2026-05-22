//
//  EstatiaBottomSheet.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaBottomSheet<Content: View>: View {

    @GestureState
    private var dragOffset: CGFloat = 0

    private let model: BottomSheetModel
    private let content: Content

    public init(
        model: BottomSheetModel,
        @ViewBuilder content: () -> Content
    ) {
        self.model = model
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {

            if model.showsGrabber {
                Capsule()
                    .fill(Color.secondary.opacity(0.5))
                    .frame(width: 48, height: 6)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
            }

            content
                .frame(maxWidth: .infinity)
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .offset(y: max(0, dragOffset))
        .gesture(dragGesture)
    }
}

private extension EstatiaBottomSheet {

    var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                guard model.allowsInteractiveDismiss else { return }
                state = max(0, value.translation.height)
            }
    }
}

#if DEBUG

private struct EstatiaBottomSheetPreviewContainer: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                // MARK: - Standard
                
                section(title: "Standard Bottom Sheet") {
                    sheetContainer {
                        
                        EstatiaBottomSheet(
                            model: BottomSheetModel()
                        ) {
                            
                            VStack(spacing: 16) {
                                Text("Bottom Sheet Content")
                                
                                Text("Interactive drag preview.")
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                    }
                }
                
                // MARK: - Long Content
                
                section(title: "Scrollable Content Stress Test") {
                    sheetContainer {
                        
                        EstatiaBottomSheet(
                            model: BottomSheetModel(
                                initialDetent: .large
                            )
                        ) {
                            
                            ScrollView {
                                VStack(spacing: 12) {
                                    
                                    ForEach(0..<20) { index in
                                        Text("Sheet Item \(index)")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(
                                                Color.gray.opacity(0.1)
                                            )
                                            .clipShape(
                                                RoundedRectangle(
                                                    cornerRadius: 12
                                                )
                                            )
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Sheet Container
    
    @ViewBuilder
    private func sheetContainer(
        @ViewBuilder content: () -> some View
    ) -> some View {
        
        ZStack(alignment: .bottom) {
            
            Color.black.opacity(0.1)
                .frame(height: 500)
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )
            
            content()
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

#Preview("Bottom Sheet - Light") {
    Preview.light {
        EstatiaBottomSheetPreviewContainer()
    }
}

#Preview("Bottom Sheet - Dark") {
    Preview.dark {
        EstatiaBottomSheetPreviewContainer()
    }
}

#endif
