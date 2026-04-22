//
//  EstatiaListForEach.swift
//  CoreDesignSystem
//
//  Created by builder on 4/22/26.
//


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
        ForEach(Array(data.enumerated()), id: \.element[keyPath: id]) { index, element in
            
            row(element)
            
            if index < data.count - 1 {
                EstatiaDivider()
            }
        }
    }
}