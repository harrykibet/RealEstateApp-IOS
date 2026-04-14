//
//  FieldController.swift
//  CoreDesignSystem
//
//  Created by builder on 4/14/26.
//

final class FieldController<Value>: ObservableObject {
    
    @Published private(set) var state: FieldState<Value>
    
    private let validator: Validator<Value>?
    private let asyncValidator: AsyncValidator<Value>?
    private let strategy: ValidationStrategy
    
    private var validationTask: Task<Void, Never>?
    
    init(
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
    
    private func shouldValidate(for event: FieldEvent) -> Bool {
        switch strategy {
        case .onChange: return event == .onChange
        case .onBlur: return event == .onBlur
        case .onSubmit: return event == .onSubmit
        case .manual: return false
        }
    }
}
