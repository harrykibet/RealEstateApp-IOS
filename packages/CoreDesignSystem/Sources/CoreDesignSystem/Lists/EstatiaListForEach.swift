//
//  EstatiaListForEach.swift
//  CoreDesignSystem
//
//  Created by builder on 4/22/26.
//

import SwiftUI

public struct EstatiaListForEach<Model, Row: View>: View
where Model: Identifiable {
    
    private let data: [Model]
    private let row: (Model) -> Row
    
    public init(
        _ data: [Model],
        @ViewBuilder row: @escaping (Model) -> Row
    ) {
        self.data = data
        self.row = row
    }
    
    public var body: some View {
        
        let lastIndex = data.count - 1
        
        ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
            
            row(item)
            
            if index < lastIndex,
               let style = (item as? any StyledListItem)?.style,
               style.showsDivider {
                
                EstatiaDivider(
                    inset: EstatiaList.resolveInset(for: style)
                )
            }
        }
    }
}
