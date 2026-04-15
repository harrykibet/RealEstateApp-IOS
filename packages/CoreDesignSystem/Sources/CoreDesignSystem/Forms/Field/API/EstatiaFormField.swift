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
    
    // MARK: - Field ID
    
    @State private let fieldID = UUID()
    
    // MARK: - Field Key
    
    private let key: FieldKey
    
    // MARK: - Field Controller
    
    @StateObject private var controller: FieldController<Value>
    
    // MARK: - Focus
    
    @FocusState private var isFocused: Bool
    
    // MARK: - Form Controller
    
    @EnvironmentObject private var formController: FormController
    
    // MARK: - Content
    
    private let content: (
        Binding<Value>,
        FieldMeta,
        FocusState<Bool>.Binding
    ) -> Content
    
    // MARK: - Init
    
    public init(
        key: FieldKey,
        value: Binding<Value>,
        validator: Validator<Value>? = nil,
        asyncValidator: AsyncValidator<Value>? = nil,
        strategy: ValidationStrategy = .onBlur,
        @ViewBuilder content: @escaping (
            Binding<Value>,
            FieldMeta,
            FocusState<Bool>.Binding
        ) -> Content
    ) {
        self.externalValue = value
        
        _controller = StateObject(
            wrappedValue: FieldController(
                id: fieldID,
                key: key,
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
        content(binding, meta, $isFocused)
            .onChange(of: isFocused, perform: handleFocusChange)
            .onChange(of: externalValue.wrappedValue, perform: syncFromExternal)
            .onAppear {
                formController.register(controller, id: fieldID, key: key)
            }
            .onDisappear {
                formController.unregister(id: fieldID, key: key)
            }
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
    
    private func handleFocusChange(_ focused: Bool) {
        if focused {
            controller.handle(event: .onFocus)
        } else {
            controller.handle(event: .onBlur)
        }
    }
    
    private func syncFromExternal(_ newValue: Value) {
        guard newValue != controller.state.value else { return }
        
        controller.setExternalValue(newValue)
    }
    
    private var meta: FieldMeta {
        FieldMeta(
            isValid: {
                switch controller.state.status {
                case .valid: return true
                case .error: return false
                case .idle: return true   // important
                case .validating: return false
                }
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

// MARK: - USAGE EXAMPLE

/*EstatiaForm { form in
    
    EstatiaFormField(
        key: .init("password"),
        value: $password
    ) { binding, meta, focus in
        
        SecureField("Password", text: binding)
            .focused(focus)
    }
    
    EstatiaFormField(
        key: .init("confirm_password"),
        value: $confirmPassword
    ) { binding, meta, focus in
        
        SecureField("Confirm Password", text: binding)
            .focused(focus)
    }
    
    Button("Submit") {
        form.submit {
            await submit()
        }
    }
}*/
