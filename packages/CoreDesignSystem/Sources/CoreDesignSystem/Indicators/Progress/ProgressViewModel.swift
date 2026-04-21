//
//  ProgressViewModel.swift
//  CoreDesignSystem
//
//  Created by builder on 4/20/26.
//

import Foundation


@MainActor
final class ProgressViewModel: ObservableObject {

    @Published var state: EstatiaProgressState = .idle
    
    let controller: ProgressController
    private var task: Task<Void, Never>?

    init(controller: ProgressController) {
        self.controller = controller
        bind()
    }

    private func bind() {
        task = Task {
            let stream = await controller.stream()
            
            for await state in stream {
                await MainActor.run {
                    self.state = state
                }
            }
        }
    }
    
    func fail() {
        Task { await controller.fail(nil) }
    }
    
    deinit {
        task?.cancel()
    }
}
