//
//  FieldStateReducer.swift
//  CoreDesignSystem
//
//  Created by builder on 4/14/26.
//


import Foundation

struct FieldStateReducer {
    
    static func reduce<Value>(
        state: inout FieldState<Value>,
        event: FieldEvent
    ) {
        switch event {
            
        case .onFocus:
            break
            
        case .onBlur:
            state.isTouched = true
            
        case .onChange:
            state.isDirty = true
            
        case .onSubmit:
            state.isTouched = true
        }
    }
    
    static func applyValidation<Value>(
        state: inout FieldState<Value>,
        result: ValidationResult
    ) {
        switch result {
        case .valid:
            state.status = .valid
            
        case .invalid(let message):
            state.status = .error(message)
        }
    }
    
    static func setValidating<Value>(
        state: inout FieldState<Value>
    ) {
        state.status = .validating
    }
}
