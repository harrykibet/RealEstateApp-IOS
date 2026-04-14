//
//  EstatiaFormField.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

public struct EstatiaFormField<Value, Content: View>: View {
    
    @StateObject private var controller: FieldController<Value>
    
    private let content: (Binding<Value>, FieldMeta) -> Content
}
