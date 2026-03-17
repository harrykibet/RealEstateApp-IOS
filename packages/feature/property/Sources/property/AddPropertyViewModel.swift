//
//  AddPropertyViewModel.swift
//  property
//
//  Created by builder on 5/10/25.
//

import Foundation
import model

public class AddPropertyViewModel: ObservableObject {
    public init(){}
    @Published public var property = PropertyModel()
}
