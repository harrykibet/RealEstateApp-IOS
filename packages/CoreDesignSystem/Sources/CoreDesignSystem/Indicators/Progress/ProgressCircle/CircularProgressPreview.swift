//
//  CircularProgressPreviewContainer.swift
//  CoreDesignSystem
//
//  Created by builder on 4/20/26.
//


//
//  EstatiaCircularProgressPreview.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//

import SwiftUI

#if DEBUG

#Preview("Circular Progress - Light (Interactive)") {
    Preview.light {
        CircularProgressPreviewContainer()
    }
}

#Preview("Circular Progress - Dark (Interactive)") {
    Preview.dark {
        CircularProgressPreviewContainer()
    }
}

// MARK: - Preview Container

private struct CircularProgressPreviewContainer: View {
    
    // MARK: - State
    
    @State private var progress: Double = 0.3
    @State private var isAnimating: Bool = false
    @State private var animatedProgress: Double = 0.0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Determinate
                
                section(title: "Determinate") {
                    VStack(spacing: 16) {
                        EstatiaCircularProgress(
                            state: .determinate(value: progress),
                            size: 48
                        )
                        
                        Slider(value: $progress, in: 0...1)
                    }
                }
                
                // MARK: - Indeterminate
                
                section(title: "Indeterminate") {
                    HStack(spacing: 24) {
                        EstatiaCircularProgress(
                            state: .indeterminate,
                            size: 40
                        )
                        
                        EstatiaCircularProgress(
                            state: .indeterminate,
                            size: 60,
                            lineWidth: 6
                        )
                    }
                }
                
                // MARK: - Terminal States
                
                section(title: "Terminal States") {
                    HStack(spacing: 24) {
                        EstatiaCircularProgress(
                            state: .success,
                            style: .success,
                            size: 48
                        )
                        
                        EstatiaCircularProgress(
                            state: .error,
                            style: .error,
                            size: 48
                        )
                    }
                }
                
                // MARK: - Styles
                
                section(title: "Styles") {
                    HStack(spacing: 24) {
                        EstatiaCircularProgress(
                            state: .determinate(value: 0.7),
                            style: .primary
                        )
                        
                        EstatiaCircularProgress(
                            state: .determinate(value: 0.7),
                            style: .success
                        )
                        
                        EstatiaCircularProgress(
                            state: .determinate(value: 0.7),
                            style: .error
                        )
                        
                        EstatiaCircularProgress(
                            state: .determinate(value: 0.7),
                            style: .warning
                        )
                    }
                }
                
                // MARK: - Sizes
                
                section(title: "Sizes & Stroke") {
                    HStack(spacing: 20) {
                        EstatiaCircularProgress(
                            state: .determinate(value: 0.6),
                            size: 32,
                            lineWidth: 3
                        )
                        
                        EstatiaCircularProgress(
                            state: .determinate(value: 0.6),
                            size: 48,
                            lineWidth: 4
                        )
                        
                        EstatiaCircularProgress(
                            state: .determinate(value: 0.6),
                            size: 72,
                            lineWidth: 8
                        )
                    }
                }
                
                // MARK: - Animation Test
                
                section(title: "Animation Test") {
                    VStack(spacing: 16) {
                        EstatiaCircularProgress(
                            state: .determinate(value: animatedProgress),
                            size: 60
                        )
                        
                        Button("Animate Progress") {
                            animateProgress()
                        }
                    }
                }
                
                // MARK: - State Machine Simulation
                
                section(title: "State Machine Simulation") {
                    ControllerDrivenCircularPreview()
                }
                
                // MARK: - Stress Test
                
                section(title: "Stress Test (Grid)") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 16) {
                        ForEach(0..<25, id: \.self) { index in
                            EstatiaCircularProgress(
                                state: .determinate(value: Double(index % 10) / 10),
                                size: 36
                            )
                        }
                    }
                }
                
                // MARK: - Edge Cases
                
                section(title: "Edge Cases") {
                    HStack(spacing: 24) {
                        EstatiaCircularProgress(
                            state: .determinate(value: -0.5),
                            size: 48
                        )
                        
                        EstatiaCircularProgress(
                            state: .determinate(value: 1.5),
                            size: 48
                        )
                        
                        EstatiaCircularProgress(
                            state: .buffered(value: 0.7, buffer: 0.2),
                            size: 48
                        )
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Controller Driven Preview

private struct ControllerDrivenCircularPreview: View {
    
    @StateObject private var vm = ProgressViewModel(
        controller: ProgressController()
    )
    
    var body: some View {
        VStack(spacing: 16) {
            EstatiaCircularProgress(
                state: vm.state,
                size: 60
            )
            
            HStack(spacing: 12) {
                Button("Start") {
                    runFlow()
                }
                
                Button("Fail") {
                    Task { await vm.controller.fail(nil) }
                }
                
                Button("Reset") {
                    Task { await vm.controller.reset() }
                }
            }
        }
    }
    
    private func runFlow() {
        Task {
            await vm.controller.startDeterminate()
            
            for i in 1...10 {
                try? await Task.sleep(nanoseconds: 200_000_000)
                await vm.controller.update(Double(i) / 10)
            }
            
            await vm.controller.complete()
        }
    }
}

// MARK: - Helpers

private extension CircularProgressPreviewContainer {
    
    func animateProgress() {
        animatedProgress = 0
        
        withAnimation(.easeInOut(duration: 2.0)) {
            animatedProgress = 1.0
        }
    }
}

#endif