import Foundation
import SwiftUI

import CoreAppData
import CoreModel

@MainActor
public final class SearchViewModel: ObservableObject {
    @Published public var searchText: String = ""
    @Published public var results: [PropertyModel] = []
    @Published public var isLoading: Bool = false

    private let repository: PropertyRepository

    public init(repository: PropertyRepository) {
        self.repository = repository
    }

    public func search() async {
        isLoading = true
        do {
            let res = try await repository.searchProperties(query: searchText.isEmpty ? nil : searchText, filters: PropertySearchFilters())
            self.results = res
        } catch {
            print("SearchViewModel.search failed: \(error)")
            self.results = []
        }
        isLoading = false
    }
}
