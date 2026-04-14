//
//  AsyncValidator.swift
//  CoreDesignSystem
//
//  Created by builder on 4/14/26.
//

public typealias AsyncValidator<Value> = (Value) async -> ValidationResult
