import SwiftUI
import FeatureHome
import FeatureSearch
import FeatureProperty
import FeatureProfile
import FeatureSettings
import FeatureComments
import FeaturePayments
import FeatureIntelligence
import FeatureFavorites
import FeatureChats
import FeatureMarket
import FeatureService
import FeatureAuth

import CoreAnalytics
import CorePlayerUI
import CorePlayerEngine
import CoreNotifications
import CoreNetwork
import CoreDatabase
import CoreSecurity
import CoreCommon
import CoreModel

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

    public enum FeatureDestination {
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
extension AppDIContainer.FeatureDestination: Equatable {
    public static func == (lhs: AppDIContainer.FeatureDestination, rhs: AppDIContainer.FeatureDestination) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home):
            return true
        case (.search, .search):
            return true
        case (.property, .property):
            return true
        case (.profile(let u1), .profile(let u2)):
            return u1.userId == u2.userId
        case (.settings, .settings):
            return true
        case (.comments, .comments):
            return true
        case (.payments, .payments):
            return true
        case (.intelligence, .intelligence):
            return true
        case (.favorites, .favorites):
            return true
        case (.chats, .chats):
            return true
        case (.market, .market):
            return true
        case (.service, .service):
            return true
        case (.player, .player):
            return true
        case (.auth, .auth):
            return true
        default:
            return false
        }
    }
}

extension AppDIContainer.FeatureDestination: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .home:
            hasher.combine(0)
        case .search:
            hasher.combine(1)
        case .property:
            hasher.combine(2)
        case .profile(let user):
            hasher.combine(3)
            hasher.combine(user.userId)
        case .settings:
            hasher.combine(4)
        case .comments:
            hasher.combine(5)
        case .payments:
            hasher.combine(6)
        case .intelligence:
            hasher.combine(7)
        case .favorites:
            hasher.combine(8)
        case .chats:
            hasher.combine(9)
        case .market:
            hasher.combine(10)
        case .service:
            hasher.combine(11)
        case .player:
            hasher.combine(12)
        case .auth:
            hasher.combine(13)
        }
    }
}

