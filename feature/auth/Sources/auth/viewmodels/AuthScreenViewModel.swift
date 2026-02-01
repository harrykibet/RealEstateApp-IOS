//
//  AuthScreenViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//


//  AuthScreenViewModel.swift
//  auth
//
//  Created by builder on 1/31/26.
//


import Foundation

@MainActor
public protocol AuthScreenViewModel: ObservableObject {
    var isLoading: Bool { get set }
    var errorMessage: String? { get set }
}