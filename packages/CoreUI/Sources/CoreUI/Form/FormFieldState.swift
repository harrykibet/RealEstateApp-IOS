//
//  FormFieldState.swift
//  CoreUI
//
//  Created by builder on 4/9/26.
//

public struct FormFieldState<Value: Equatable>: Equatable {
    
    public var value: Value
    public var error: String?
    public var isDirty: Bool
    public var isFocused: Bool
    
    public init(
        value: Value,
        error: String? = nil,
        isDirty: Bool = false,
        isFocused: Bool = false
    ) {
        self.value = value
        self.error = error
        self.isDirty = isDirty
        self.isFocused = isFocused
    }
}
