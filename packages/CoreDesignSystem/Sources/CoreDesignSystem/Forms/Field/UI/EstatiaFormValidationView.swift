//
//  EstatiaFormValidationView.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

//
//  EstatiaFormValidationView.swift
//  CoreDesignSystem
//

import SwiftUI

public struct EstatiaFormValidationView: View {
    
    // MARK: - Properties
    
    private let meta: FieldMeta
    private let helperText: String?
    
    @Environment(\.theme) private var theme
    
    // MARK: - Init
    
    public init(
        meta: FieldMeta,
        helperText: String? = nil
    ) {
        self.meta = meta
        self.helperText = helperText
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            if shouldShowError, let error = meta.error {
                EstatiaText(error, style: .caption)
                    .foregroundColor(theme.colors.error)
                    .transition(.opacity)
            }
            
            else if let helperText {
                EstatiaText(helperText, style: .caption)
                    .foregroundColor(theme.colors.textSecondary)
            }
        }
        .animation(.easeInOut, value: meta.error)
    }
    
    // MARK: - Logic (minimal & safe)
    
    private var shouldShowError: Bool {
        meta.isTouched && meta.error != nil
    }
}
