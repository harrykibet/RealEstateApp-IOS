//
//  FormController.swift
//  CoreDesignSystem
//
//  Created by builder on 4/15/26.
//

import Foundation

@MainActor
public final class FormController: ObservableObject {
    
    // MARK: - Registered Fields
    
    private var fieldsByID: [UUID: WeakFieldController] = [:]
    
    // MARK: - Key Index
    
    private var keyIndex: [FieldKey: UUID] = [:]
    
    // MARK: - Cross Field Validators
    
    private var crossValidators: [CrossFieldValidator] = []
    
    // MARK: - Submission State
    
    @Published private(set) var submissionState: FormSubmissionState = .idle
    
    // MARK: - Registration
    
    func register(_ field: AnyFieldController, id: UUID, key: FieldKey) {
        
        // lifecycle map
        fieldsByID[id] = WeakFieldController(value: field, id: id)
        
        assert(keyIndex[key] == nil, "Duplicate FieldKey registration: \(key.rawValue)")
        
        // logical map
        keyIndex[key] = id
    }
    
    // MARK: - Unregistration
    
    func unregister(id: UUID, key: FieldKey) {
        
        fieldsByID.removeValue(forKey: id)
        
        keyIndex.removeValue(forKey: key)
    }
    
    // MARK: - Key-Based Lookup
    
    func field(for key: FieldKey) -> AnyFieldController? {
        
        guard let id = keyIndex[key] else { return nil }
        
        return fieldsByID[id]?.value
    }
    
    // MARK: - Clean Up
    
    private func cleanup() {
        fieldsByID = fieldsByID.filter { $0.value.value != nil }
    }
    
    // MARK: - Add Validator
    
    func addValidator(_ validator: CrossFieldValidator) {
        crossValidators.append(validator)
    }
    
    // MARK: - Run Cross Validation
    
    private func runCrossValidation() {
        cleanup()
        
        var fieldsByKeyMap: [FieldKey: AnyFieldController] = [:]
        
        for (_, wrapper) in fieldsByID {
            if let field = wrapper.value {
                fieldsByKeyMap[field.key] = field
            }
        }
        
        for validator in crossValidators {
            let errors = validator.validate(fieldsByKeyMap)
            
            for (key, field) in fieldsByKeyMap {
                let message = errors[key] 
                field.setExternalError(message)
            }
        }
    }
    
    // MARK: - Validation
    
    func validateAll() -> Bool {
        cleanup()
        
        var isValid = true
        
        for wrapper in fieldsByID.values {
            guard let field = wrapper.value else { continue }
            
            let result = field.forceValidate()
            if !result {
                isValid = false
            }
        }
        
        runCrossValidation()
        
        return fieldsByID.values.allSatisfy {
            guard let field = $0.value else { return true }
            return field.validate()
        }
    }
    
    // MARK: - Submit
    
    func submit(action: @escaping () async throws -> Void) {
        guard !submissionState.isLoading else { return }
        
        let valid = validateAll()
        guard valid else { return }
        
        submissionState = .loading
        
        Task { @MainActor in
            do {
                try await action()
                submissionState = .success
            } catch {
                submissionState = .error(error.localizedDescription)
            }
        }
    }
}
