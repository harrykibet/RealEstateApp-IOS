//
//  AnyFieldController.swift
//  CoreDesignSystem
//
//  Created by builder on 4/15/26.
//


public protocol AnyFieldController {
    func validate() -> Bool
}


private extension FieldController: AnyFieldController {
    
    func validate() -> Bool {
        handle(event: .onSubmit)
        
        if case .error = state.status {
            return false
        }
        
        return true
    }
}
