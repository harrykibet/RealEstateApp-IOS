//
//  URLSessionNetworkClient.swift
//  CoreNetwork
//
//  Created by builder on 4/30/26.
//

import Foundation


public final class URLSessionNetworkClient: NetworkClient {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetch(_ url: URL) async throws -> (Data, URLResponse) {
        try await session.data(from: url)
    }
}
