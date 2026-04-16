//
//  FormSubmissionState.swift
//  CoreDesignSystem
//
//  Created by builder on 4/15/26.
//

public enum FormSubmissionState {
    
    case idle
    
    case loading
    
    case success
    
    case error(String)
}

extension FormSubmissionState {
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}
