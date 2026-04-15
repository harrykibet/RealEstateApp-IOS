//
//  EstatiaForm.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaForm<Content: View>: View {
    
    // MARK: - Controller
    
    @StateObject private var controller = FormController()
    
    // MARK: - Content
    
    private let content: (FormController) -> Content
    
    // MARK: - Init
    
    public init(
        @ViewBuilder content: @escaping (FormController) -> Content
    ) {
        self.content = content
    }
    
    // MARK: - Body
    
    public var body: some View {
        content(controller)
            .environmentObject(controller)
    }
}
