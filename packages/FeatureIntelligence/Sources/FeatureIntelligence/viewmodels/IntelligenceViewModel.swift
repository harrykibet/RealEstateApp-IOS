import SwiftUI

public final class IntelligenceViewModel: ObservableObject {
    public enum State: Equatable {
        case idle
        case loading
        case error(String)
    }

    @Published public private(set) var state: State
    @Published public var title: String
    @Published public var subtitle: String

    public init(
        title: String = "Intelligence",
        subtitle: String = "Insights and recommendations",
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
