//
//  EstatiaFormField.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

//
//  EstatiaFormField.swift
//

import SwiftUI

public struct EstatiaFormField<Value: Equatable, Content: View>: View {
    
    // MARK: - External Binding
    
    private let externalValue: Binding<Value>
    
    // MARK: - Controller
    
    @StateObject private var controller: FieldController<Value>
    
    // MARK: - Content
    
    private let content: (Binding<Value>, FieldMeta) -> Content
    
    // MARK: - Init
    
    public init(
        value: Binding<Value>,
        validator: Validator<Value>? = nil,
        asyncValidator: AsyncValidator<Value>? = nil,
        strategy: ValidationStrategy = .onBlur,
        @ViewBuilder content: @escaping (Binding<Value>, FieldMeta) -> Content
    ) {
        self.externalValue = value
        
        _controller = StateObject(
            wrappedValue: FieldController(
                initialValue: value.wrappedValue,
                validator: validator,
                asyncValidator: asyncValidator,
                strategy: strategy
            )
        )
        
        self.content = content
    }
    
    // MARK: - Body
    
    public var body: some View {
        content(binding, meta)
            .onChange(of: externalValue.wrappedValue, perform: syncFromExternal)
    }
    
    private var binding: Binding<Value> {
        Binding(
            get: {
                controller.state.value
            },
            set: { newValue in
                controller.updateValue(newValue)
                externalValue.wrappedValue = newValue
            }
        )
    }
    
    private func syncFromExternal(_ newValue: Value) {
        guard newValue != controller.state.value else { return }
        
        controller.setExternalValue(newValue)
    }
    
    private var meta: FieldMeta {
        FieldMeta(
            isValid: {
                if case .valid = controller.state.status { return true }
                return false
            }(),
            error: {
                if case .error(let message) = controller.state.status {
                    return message
                }
                return nil
            }(),
            isTouched: controller.state.isTouched,
            isValidating: {
                if case .validating = controller.state.status { return true }
                return false
            }()
        )
    }
}
