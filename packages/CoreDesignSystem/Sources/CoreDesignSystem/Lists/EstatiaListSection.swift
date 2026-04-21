//
//  EstatiaListSection.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaListSection<Header: View, Content: View, Footer: View>: View {
    
    private let header: Header?
    private let content: Content
    private let footer: Footer?
    
    public init(
        @ViewBuilder header: () -> Header? = { nil },
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer? = { nil }
    ) {
        self.header = header()
        self.content = content()
        self.footer = footer()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            
            content
            
            footer
        }
    }
}
