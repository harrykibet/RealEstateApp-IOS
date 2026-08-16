import SwiftUI
import CoreModel
import CoreDesignSystem

public final class AppCoordinator: ObservableObject {
    // Use the shared AppTabID from CoreDesignSystem for consistency across the app
    public typealias AppTab = AppTabID

    private let navigationState: NavigationState
    public let container: AppDIContainer

    public init(container: AppDIContainer, navigationState: NavigationState) {
        self.container = container
        self.navigationState = navigationState
    }

    // Expose selectedTab as a façade to the central NavigationState
    public var selectedTab: AppTab {
        get { navigationState.selectedTab }
        set { Task { await MainActor.run { self.navigationState.selectedTab = newValue } } }
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

