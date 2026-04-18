//
//  EstatiaChipContent.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//


public struct EstatiaChipContent {
    public let title: String
    public let leadingIcon: String?
    public let trailingIcon: String?
    
    public init(
        title: String,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil
    ) {
        self.title = title
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
    }
}