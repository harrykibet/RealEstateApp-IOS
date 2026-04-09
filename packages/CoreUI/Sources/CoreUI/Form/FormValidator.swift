//
//  FormValidator.swift
//  CoreUI
//
//  Created by builder on 4/9/26.
//

public protocol FormValidator {
    associatedtype Value
    
    func validate(_ value: Value) -> String?
}
