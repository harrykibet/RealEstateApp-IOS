import SwiftUI
import model

import home
import search
import property
import profile
import settings
import comments
import payments
import intelligence
import favorites
import chats
import market
import service
import player
import auth

import analytics
import notifications
import network
import database
import security
import common

public final class AppDIContainer {
    public struct AppScope {
        public let logger: Logger
        public let analytics: AnalyticsClient
        public let notifications: NotificationsClient
        public let apiClient: APIClient
        public let database: DatabaseClient
        public let secureStore: SecureStore
        public let currentUser: User

        public init(
            logger: Logger,
            analytics: AnalyticsClient,
            notifications: NotificationsClient,
            apiClient: APIClient,
            database: DatabaseClient,
            secureStore: SecureStore,
            currentUser: User
        ) {
            self.logger = logger
            self.analytics = analytics
            self.notifications = notifications
            self.apiClient = apiClient
            self.database = database
            self.secureStore = secureStore
            self.currentUser = currentUser
        }
    }

    public struct FeatureScope {
        public let appScope: AppScope

        public init(appScope: AppScope) {
            self.appScope = appScope
        }
    }

    public enum FeatureDestination: Hashable {
        case home
        case search
        case property
        case profile(User)
        case settings
        case comments
        case payments
        case intelligence
        case favorites
        case chats
        case market
        case service
        case player
        case auth
    }

    public let appScope: AppScope

    public init() {
        let mockUser = User(
            userId: "demo_001",
            name: "Harry Kibet",
            email: "harry@example.com",
            phoneNumber: "+254712345678",
            profilePictureUrl: "https://i.pravatar.cc/150?img=3",
            userType: .landlord,
            verified: true,
            likedProperties: ["property_a", "property_b"]
        )

        self.appScope = AppScope(
            logger: ConsoleLogger(),
            analytics: NoopAnalyticsClient(),
            notifications: NoopNotificationsClient(),
            apiClient: NoopAPIClient(),
            database: InMemoryDatabaseClient(),
            secureStore: InMemorySecureStore(),
            currentUser: mockUser
        )
    }

    public func makeFeatureScope() -> FeatureScope {
        FeatureScope(appScope: appScope)
    }

    public func makeView(for destination: FeatureDestination) -> AnyView {
        switch destination {
        case .home:
            return AnyView(HomeView())
        case .search:
            return AnyView(SearchView())
        case .property:
            return AnyView(AddPropertyView())
        case .profile(let user):
            return AnyView(UserProfileView(user: user))
        case .settings:
            return AnyView(SettingsView(viewModel: SettingsViewModel()))
        case .comments:
            return AnyView(CommentsView(viewModel: CommentsViewModel()))
        case .payments:
            return AnyView(PaymentsView(viewModel: PaymentsViewModel()))
        case .intelligence:
            return AnyView(IntelligenceView(viewModel: IntelligenceViewModel()))
        case .favorites:
            return AnyView(FavoritesView(viewModel: FavoritesViewModel()))
        case .chats:
            return AnyView(ChatsView(viewModel: ChatsViewModel()))
        case .market:
            return AnyView(MarketView(viewModel: MarketViewModel()))
        case .service:
            return AnyView(ServiceView(viewModel: ServiceViewModel()))
        case .player:
            return AnyView(PlayerView(viewModel: PlayerViewModel()))
        case .auth:
            return AnyView(AuthView(viewModel: AuthViewModel()))
        }
    }
}
