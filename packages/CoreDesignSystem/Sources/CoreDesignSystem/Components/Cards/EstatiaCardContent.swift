//
//  EstatiaCardContent.swift
//  CoreDesignSystem
//
//  Created by builder on 4/6/26.
//

import SwiftUI

public struct EstatiaCardContent<Content: View>: View {
    
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
    }
}
