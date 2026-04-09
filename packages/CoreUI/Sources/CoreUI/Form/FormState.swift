//
//  FormState.swift
//  CoreUI
//
//  Created by builder on 4/9/26.
//

public struct FormState: Equatable {
    
    public var isSubmitting: Bool
    public var isValid: Bool
    
    public init(
        isSubmitting: Bool = false,
        isValid: Bool = false
    ) {
        self.isSubmitting = isSubmitting
        self.isValid = isValid
    }
}
