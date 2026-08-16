import Foundation
import SwiftUI

import CoreAppData
import CoreModel

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published public var properties: [PropertyModel] = []
    
    private let repository: PropertyRepository
    
    public init(repository: PropertyRepository) {
        self.repository = repository
    }
    
    public func load() async {
        do {
            let results = try await repository.fetchProperties()
            self.properties = results
        } catch {
            // Replace with a proper error handling strategy
            print("HomeViewModel.load() failed: \(error)")
        }
    }
}
