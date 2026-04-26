//
//  FieldController.swift
//  CoreDesignSystem
//
//  Created by builder on 4/14/26.
//

import Foundation

@MainActor
final class FieldController<Value: Equatable & Sendable>: ObservableObject {
    
    @Published private(set) var state: FieldState<Value>
    
    private let validator: Validator<Value>?
    private let asyncValidator: AsyncValidator<Value>?
    private let strategy: ValidationStrategy
    
    let id: UUID
    
    let key: FieldKey
    
    private var validationTask: Task<Void, Never>?
    
    init(
        id: UUID = UUID(),
        key: FieldKey,
        initialValue: Value,
        validator: Validator<Value>? = nil,
        asyncValidator: AsyncValidator<Value>? = nil,
        strategy: ValidationStrategy = .onBlur
    ) {
        self.state = FieldState(
            value: initialValue,
            isDirty: false,
            isTouched: false,
            status: .idle
        )
        
        self.id = id
        self.key = key
        self.validator = validator
        self.asyncValidator = asyncValidator
        self.strategy = strategy
    }
    
    func updateValue(_ newValue: Value) {
        state.value = newValue
        state.isDirty = true
        
        handle(event: .onChange)
    }
    
    func handle(event: FieldEvent) {
        switch event {
        case .onBlur:
            state.isTouched = true
        default:
            break
        }
        
        if shouldValidate(for: event) {
            validate()
        }
    }
    
    func applyExternalError(_ message: String?) {
        if let message {
            state.status = .error(message)
        } else {
            if case .error = state.status {
                state.status = .valid
            }
        }
    }
    
    func applyEvent(_ event: FieldEvent) {
        FieldStateReducer.reduce(
            state: &state,
            event: event
        )
    }
    
    private func shouldValidate(for event: FieldEvent) -> Bool {
        switch strategy {
        case .onChange: return event == .onChange
        case .onBlur: return event == .onBlur
        case .onSubmit: return event == .onSubmit
        case .manual: return false
        }
    }
    
    private func runValidation() {
        validationTask?.cancel()
        
        if let validator {
            let result = validator(state.value)
            applyValidation(result)
        }
        
        guard let asyncValidator else { return }
        
        FieldStateReducer.setValidating(state: &state)
        
        let currentValue = state.value

        validationTask = Task { [weak self] in
            guard let self else { return }
            
            let result = await asyncValidator(currentValue)
            
            guard !Task.isCancelled else { return }
            guard self.state.value == currentValue else { return } 
            
            self.applyValidation(result)
        }
    }
    
    private func applyValidation(_ result: ValidationResult) {
        FieldStateReducer.applyValidation(
            state: &state,
            result: result
        )
    }
    
    func setExternalValue(_ value: Value) {
        state.value = value
    }
}

@MainActor
extension FieldController: AnyFieldController {
        
    func validate() -> Bool {
        handle(event: .onSubmit)
        
        if case .error = state.status {
            return false
        }
        
        return true
    }
    
    func forceValidate() -> Bool {
        handle(event: .onSubmit)
        
        if case .error = state.status {
            return false
        }
        
        return true
    }
    
    func getValue() -> Any {
        
        state.value
    }
    
    func setExternalError(_ message: String?) {
        
        applyExternalError(message)
    }
}

