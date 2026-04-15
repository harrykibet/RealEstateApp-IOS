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
    
    private var fields: [AnyFieldController] = []
    
    // MARK: - Submission State
    
    @Published private(set) var submissionState: FormSubmissionState = .idle
    
    // MARK: - Registration
    
    func register(_ field: AnyFieldController) {
        fields.append(field)
    }
    
    // MARK: - Validation
    
    func validateAll() -> Bool {
        var isValid = true
        
        for field in fields {
            let result = field.validate()
            if !result {
                isValid = false
            }
        }
        
        return isValid
    }
    
    // MARK: - Submit
    
    func submit(action: @escaping () async -> Void) {
        let valid = validateAll()
        
        guard valid else { return }
        
        submissionState = .loading
        
        Task {
            await action()
            
            submissionState = .success
        }
    }
}
