//
//  EstatiaProgressBarPreview.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//

import SwiftUI

#if DEBUG

#Preview("ProgressBar - Light (Interactive)") {
    Preview.light {
        ProgressPreviewContainer()
    }
}

#Preview("ProgressBar - Dark (Interactive)") {
    Preview.dark {
        ProgressPreviewContainer()
    }
}

// MARK: - Preview Container

private struct ProgressPreviewContainer: View {
    
    // MARK: - State
    
    @State private var progress: Double = 0.25
    @State private var buffer: Double = 0.5
    @State private var isLoading: Bool = false
    @State private var isError: Bool = false
    @State private var isSuccess: Bool = false
    
    @State private var animatedProgress: Double = 0.0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Determinate
                
                section(title: "Determinate") {
                    EstatiaProgressBar(
                        state: .determinate(value: progress),
                        label: "Upload Progress"
                    )
                    
                    Slider(value: $progress, in: 0...1)
                }
                
                // MARK: - Buffered
                
                section(title: "Buffered (Streaming)") {
                    EstatiaProgressBar(
                        state: .buffered(value: progress, buffer: buffer),
                        label: "Video Buffer"
                    )
                    
                    VStack {
                        Text("Progress")
                        Slider(value: $progress, in: 0...1)
                        
                        Text("Buffer")
                        Slider(value: $buffer, in: 0...1)
                    }
                }
                
                // MARK: - Indeterminate
                
                section(title: "Indeterminate") {
                    EstatiaProgressBar(
                        state: .indeterminate,
                        label: "Processing..."
                    )
                }
                
                // MARK: - Terminal States
                
                section(title: "Terminal States") {
                    VStack(spacing: 12) {
                        EstatiaProgressBar(
                            state: .success,
                            style: .success,
                            label: "Completed"
                        )
                        
                        EstatiaProgressBar(
                            state: .error,
                            style: .error,
                            label: "Failed"
                        )
                    }
                }
                
                // MARK: - Styles
                
                section(title: "Styles") {
                    VStack(spacing: 12) {
                        EstatiaProgressBar(
                            state: .determinate(value: 0.6),
                            style: .primary,
                            label: "Primary"
                        )
                        
                        EstatiaProgressBar(
                            state: .determinate(value: 0.6),
                            style: .success,
                            label: "Success"
                        )
                        
                        EstatiaProgressBar(
                            state: .determinate(value: 0.6),
                            style: .error,
                            label: "Error"
                        )
                        
                        EstatiaProgressBar(
                            state: .determinate(value: 0.6),
                            style: .warning,
                            label: "Warning"
                        )
                    }
                }
                
                // MARK: - State Machine Simulation
                
                section(title: "State Machine Simulation") {
                    
                    EstatiaProgressBar(
                        state: simulatedState,
                        label: "Simulated Flow"
                    )
                    
                    HStack(spacing: 12) {
                        Button("Start") {
                            startSimulation()
                        }
                        
                        Button("Error") {
                            isError = true
                            isSuccess = false
                            isLoading = false
                        }
                        
                        Button("Reset") {
                            reset()
                        }
                    }
                }
                
                // MARK: - Stress Test
                
                section(title: "Stress Test (List Rendering)") {
                    VStack(spacing: 12) {
                        ForEach(0..<30, id: \.self) { index in
                            EstatiaProgressBar(
                                state: .buffered(
                                    value: Double(index % 10) / 10.0,
                                    buffer: Double((index + 3) % 10) / 10.0
                                ),
                                label: "Item \(index)"
                            )
                        }
                    }
                }
                
                // MARK: - Animation Test
                
                section(title: "Animation Test") {
                    EstatiaProgressBar(
                        state: .determinate(value: animatedProgress),
                        label: "Auto Progress"
                    )
                    
                    Button("Animate") {
                        animateProgress()
                    }
                }
                
                // MARK: - Edge Cases
                
                section(title: "Edge Cases") {
                    VStack(spacing: 12) {
                        EstatiaProgressBar(
                            state: .determinate(value: -0.5),
                            label: "Below 0"
                        )
                        
                        EstatiaProgressBar(
                            state: .determinate(value: 1.5),
                            label: "Above 1"
                        )
                        
                        EstatiaProgressBar(
                            state: .buffered(value: 0.8, buffer: 0.3),
                            label: "Buffer < Progress"
                        )
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - State Simulation

private extension ProgressPreviewContainer {
    
    var simulatedState: EstatiaProgressState {
        if isError {
            return .error
        }
        
        if isSuccess {
            return .success
        }
        
        if isLoading {
            return .indeterminate
        }
        
        return .determinate(value: progress)
    }
    
    func startSimulation() {
        reset()
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            progress = 0.0
            runProgressLoop()
        }
    }
    
    func runProgressLoop() {
        guard progress < 1.0 else {
            isSuccess = true
            return
        }
        
        progress += 0.1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            runProgressLoop()
        }
    }
    
    func animateProgress() {
        animatedProgress = 0
        
        withAnimation(.easeInOut(duration: 2.0)) {
            animatedProgress = 1.0
        }
    }
    
    func reset() {
        progress = 0.25
        buffer = 0.5
        isLoading = false
        isError = false
        isSuccess = false
    }
}


#endif
