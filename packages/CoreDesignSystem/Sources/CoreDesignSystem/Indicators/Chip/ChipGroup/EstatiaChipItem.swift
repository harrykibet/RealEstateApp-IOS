//
//  EstatiaChipItem.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//


public struct EstatiaChipItem: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let leadingIcon: String?
    
    public init(
        id: String,
        title: String,
        leadingIcon: String? = nil
    ) {
        self.id = id
        self.title = title
        self.leadingIcon = leadingIcon
    }
}