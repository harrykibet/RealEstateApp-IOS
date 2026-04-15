//
//  FormController.swift
//  CoreDesignSystem
//
//  Created by builder on 4/15/26.
//

import Foundation

@MainActor
final class FormController: ObservableObject {
    
    // MARK: - Registered Fields
    
    private var fields: [UUID: WeakFieldController] = [:]
    
    // MARK: - Submission State
    
    @Published private(set) var submissionState: FormSubmissionState = .idle
    
    // MARK: - Registration
    
    func register(_ field: AnyFieldController, id: UUID) {
        
        fields[id] = WeakFieldController(value: field, id: id)
        
    }
    
    // MARK: - Unregistration
    
    func unregister(id: UUID) {
        fields.removeValue(forKey: id)
    }
    
    // MARK: - Clean Up
    
    private func cleanup() {
        fields = fields.filter { $0.value.value != nil }
    }
    
    // MARK: - Validation
    
    func validateAll() -> Bool {
        cleanup()
        
        var isValid = true
        
        for wrapper in fields.values {
            guard let field = wrapper.value else { continue }
            
            let result = field.forceValidate()
            if !result {
                isValid = false
            }
        }
        
        return isValid
    }
    
    // MARK: - Submit
    
    func submit(action: @escaping () async throws -> Void) {
        guard submissionState != .loading else { return }
        
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
