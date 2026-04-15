//
//  AnyFieldController.swift
//  CoreDesignSystem
//
//  Created by builder on 4/15/26.
//


protocol AnyFieldController: AnyObject {
    
    var id: UUID { get }
    
    func validate() -> Bool
    func forceValidate() -> Bool
    
    func getValue() -> Any
    func setExternalError(_ message: String?)
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
    
    func getValue() -> Any {
        state.value
    }
    
    func setExternalError(_ message: String?) {
        if let message {
            state.status = .error(message)
        } else {
            if case .error = state.status {
                state.status = .valid
            }
        }
    }
}
