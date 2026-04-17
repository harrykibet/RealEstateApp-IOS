//
//  AnyFieldController.swift
//  CoreDesignSystem
//
//  Created by builder on 4/15/26.
//

import Foundation

@MainActor
protocol AnyFieldController: AnyObject {
    
    var id: UUID { get }
    var key: FieldKey { get }
    
    func validate() -> Bool
    func forceValidate() -> Bool
    
    func getValue() -> Any
    func setExternalError(_ message: String?)
}


