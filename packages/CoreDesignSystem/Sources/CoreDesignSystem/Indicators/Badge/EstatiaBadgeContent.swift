//
//  EstatiaBadgeContent.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//


public enum EstatiaBadgeContent: Equatable {
    case text(String)
    case count(Int)
    case icon(systemName: String)
}