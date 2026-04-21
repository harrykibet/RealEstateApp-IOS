//
//  EstatiaListSection.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

public struct EstatiaListSection<Header: View, Content: View, Footer: View>: View {
    
    let header: Header?
    let content: Content
    let footer: Footer?
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if let header = header {
                header
                    .padding(.bottom, theme.spacing.xs)
            }
            
            content
            
            if let footer = footer {
                footer
                    .padding(.top, theme.spacing.xs)
            }
        }
    }
}
