//
//  NetworkClient.swift
//  CoreNetwork
//
//  Created by builder on 4/30/26.
//

import Foundation


public protocol NetworkClient: Sendable {
    func fetch(_ url: URL) async throws -> (Data, URLResponse)
}
