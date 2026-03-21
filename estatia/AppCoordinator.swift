import SwiftUI
import CoreModel

public final class AppCoordinator: ObservableObject {
    public enum AppTab: Hashable {
        case home
        case search
        case add
        case profile
    }

    @Published public var selectedTab: AppTab = .home
    public let container: AppDIContainer

    public init(container: AppDIContainer) {
        self.container = container
    }

    public var currentUser: User {
        container.appScope.currentUser
    }

    public func makeRootView() -> some View {
        MainTabView(coordinator: self)
    }

    public func view(for destination: AppDIContainer.FeatureDestination) -> AnyView {
        container.makeView(for: destination)
    }
}
