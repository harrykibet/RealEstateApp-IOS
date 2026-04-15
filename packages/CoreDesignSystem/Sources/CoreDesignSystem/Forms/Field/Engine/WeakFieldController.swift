//
//  WeakFieldController.swift
//  CoreDesignSystem
//
//  Created by builder on 4/15/26.
//


public final class WeakFieldController {
    
    weak var value: AnyFieldController?
    let id: UUID
    
    init(value: AnyFieldController, id: UUID) {
        self.value = value
        self.id = id
    }
}
