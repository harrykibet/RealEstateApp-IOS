//
//  ProgressViewModel.swift
//  CoreDesignSystem
//
//  Created by builder on 4/20/26.
//


@MainActor
final class ProgressViewModel: ObservableObject {

    @Published var state: EstatiaProgressState = .idle
    
    private let controller: ProgressController
    private var task: Task<Void, Never>?

    init(controller: ProgressController) {
        self.controller = controller
        bind()
    }

    private func bind() {
        task = Task {
            for await state in controller.stream() {
                self.state = state
            }
        }
    }

    deinit {
        task?.cancel()
    }
}