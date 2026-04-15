//
//  AnyFieldController.swift
//  CoreDesignSystem
//
//  Created by builder on 4/15/26.
//


public protocol AnyFieldController {
    
    func validate() -> Bool
    
    func forceValidate() -> Bool
}


private extension FieldController: AnyFieldController {
    
    func validate() -> Bool {
        handle(event: .onSubmit)
        
        if case .error = state.status {
            return false
        }
        
        return true
    }
    
    func forceValidate() -> Bool {
        // 🔥 Force touched
        FieldStateReducer.reduce(
            state: &state,
            event: .onSubmit
        )
        
        validate()
    }
}
