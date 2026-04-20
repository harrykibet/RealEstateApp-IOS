//
//  ProgressReducer.swift
//  CoreDesignSystem
//
//  Created by builder on 4/20/26.
//


private struct ProgressReducer {

    static func reduce(
        state: EstatiaProgressState,
        event: ProgressEvent
    ) -> EstatiaProgressState {
        
        switch (state, event) {

        // MARK: - Start
        
        case (.idle, .startIndeterminate):
            return .indeterminate
            
        case (.idle, .startDeterminate):
            return .determinate(value: 0)

        // MARK: - Determinate
        
        case (.determinate, .updateProgress(let value)):
            return .determinate(value: clamp(value))

        case (.determinate, .complete):
            return .success

        case (.determinate, .fail(let error)):
            return .error(reason: error)

        // MARK: - Buffered
        
        case (.buffered, .updateBuffered(let value, let buffer)):
            return .buffered(
                value: clamp(value),
                buffer: clamp(buffer)
            )

        case (.buffered, .complete):
            return .success

        case (.buffered, .fail(let error)):
            return .error(reason: error)

        // MARK: - Indeterminate
        
        case (.indeterminate, .complete):
            return .success

        case (.indeterminate, .fail(let error)):
            return .error(reason: error)

        // MARK: - Reset
        
        case (_, .reset):
            return .idle

        // MARK: - Invalid transitions (guardrail)
        
        default:
            return state // no-op (or assert in debug)
        }
    }

    private static func clamp(_ value: Double) -> Double {
        min(max(value, 0), 1)
    }
}