//
//  AddPropertyViewModel.swift
//  property
//
//  Created by builder on 5/10/25.
//

import Foundation
import CoreModel

public class AddPropertyViewModel: ObservableObject {
    public init(){}
    @Published public var property = PropertyModel()
}
