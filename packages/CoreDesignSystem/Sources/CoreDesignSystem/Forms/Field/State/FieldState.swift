//
//  FieldState.swift
//  CoreDesignSystem
//
//  Created by builder on 4/14/26.
//

struct FieldState<Value> {
    
    var value: Value
    
    var isDirty: Bool
    var isTouched: Bool
    
    var status: FieldStatus
}
