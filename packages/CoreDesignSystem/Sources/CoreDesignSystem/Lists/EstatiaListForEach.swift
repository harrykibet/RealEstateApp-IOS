//
//  EstatiaListForEach.swift
//  CoreDesignSystem
//
//  Created by builder on 4/22/26.
//

import SwiftUI

private struct IndexedItem<Element, ID: Hashable>: Identifiable {
    let index: Int
    let element: Element
    let id: ID
}

private struct RenderItem<Element, ID: Hashable>: Identifiable {
    let index: Int
    let element: Element
    let id: ID
    let showsDivider: Bool
}

public struct EstatiaListForEach<Data, ID, Row: View>: View
where Data: RandomAccessCollection, ID: Hashable {
    
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let row: (Data.Element) -> Row
    
    public init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder row: @escaping (Data.Element) -> Row
    ) {
        self.data = data
        self.id = id
        self.row = row
    }
    
    public var body: some View {
        
        let items = Array(data)
        let lastIndex = items.count - 1
        
        ForEach(Array(items.enumerated()), id: \.element[keyPath: id]) { pair in
            
            let index = pair.offset
            let element = pair.element
            
            row(element)
            
            if index < lastIndex {
                EstatiaDivider(
                    inset: resolveInset(for: element)
                )
            }
        }
    }
}
