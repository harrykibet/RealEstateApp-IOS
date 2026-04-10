//
//  ScreenState.swift
//  CoreUI
//
//  Created by builder on 4/9/26.
//

import Foundation

public enum ScreenState<Content> {
    
    case loading
    
    case error(message: String)
    
    case empty
    
    case content(Content)
}
