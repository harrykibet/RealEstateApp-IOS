import SwiftUI

public final class FavoritesViewModel: ObservableObject {
    public enum State: Equatable {
        case idle
        case loading
        case error(String)
    }

    @Published public private(set) var state: State
    @Published public var title: String
    @Published public var subtitle: String

    public init(
        title: String = "Favorites",
        subtitle: String = "Your saved listings",
        state: State = .idle
    ) {
        self.title = title
        self.subtitle = subtitle
        self.state = state
    }

    public func onAppear() {
        // Hook for loading data later.
    }
}
