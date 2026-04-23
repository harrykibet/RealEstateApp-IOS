//
//  EstatiaListItemModel.swift
//  CoreDesignSystem
//
//  Created by builder on 4/23/26.
//


public struct EstatiaListItemModel<Element>: Identifiable {
    
    public let id: AnyHashable
    public let element: Element
    public let style: EstatiaListItemStyle
    
    public init<ID: Hashable>(
        id: ID,
        element: Element,
        style: EstatiaListItemStyle
    ) {
        self.id = AnyHashable(id)
        self.element = element
        self.style = style
    }
}

extension EstatiaListItemModel: StyledListItem {}
