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
        
        let indexedItems = items.enumerated().map {
            IndexedItem(
                index: $0.offset,
                element: $0.element,
                id: $0.element[keyPath: id]
            )
        }
        
        let renderItems = indexedItems.map { item in
            RenderItem(
                element: item.element,
                showsDivider: item.index < lastIndex
            )
        }
        
        ForEach(renderItems, id: \.element[keyPath: id]) { item in
            
            row(item.element)
            
            if item.showsDivider {
                EstatiaDivider(
                    inset: DividerInset(for: item.element)
                )
            }
        }
    }
}
