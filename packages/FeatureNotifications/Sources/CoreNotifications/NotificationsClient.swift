import Foundation

public struct NotificationRequest: Equatable {
    public let id: String
    public let title: String
    public let body: String

    public init(id: String, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
}

public protocol NotificationsClient {
    func requestAuthorization() async throws
    func schedule(_ request: NotificationRequest) async throws
}

public final class NoopNotificationsClient: NotificationsClient {
    public init() {}

    public func requestAuthorization() async throws {}

    public func schedule(_ request: NotificationRequest) async throws {}
}
