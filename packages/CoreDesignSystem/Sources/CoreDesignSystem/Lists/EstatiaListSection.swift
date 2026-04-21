//
//  EstatiaListSection.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaListSection<Header: View, Content: View, Footer: View>: View {
    
    let header: Header?
    let content: Content
    let footer: Footer?
    
    @Environment(\.theme) private var theme
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if let header = header {
                header
                    .padding(.bottom, theme.dimensions.spacing.xs)
            }
            
            content
            
            if let footer = footer {
                footer
                    .padding(.top, theme.dimensions.spacing.xs)
            }
        }
    }
}
