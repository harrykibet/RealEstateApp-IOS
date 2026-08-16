import Foundation
import SwiftUI

import CoreAppData
import CoreModel

@MainActor
public final class ProfileViewModel: ObservableObject {
    @Published public var user: User
    @Published public var favoriteCount: Int = 0

    private let repository: UserRepository

    public init(repository: UserRepository, initialUser: User) {
        self.repository = repository
        self.user = initialUser
    }

    public func refresh() async {
        guard let id = user.userId as String? else { return }
        do {
            let updated = try await repository.fetchUser(id: id)
            self.user = updated
            let favorites = try await repository.fetchFavoritePropertyIds(userId: id)
            self.favoriteCount = favorites.count
        } catch {
            print("ProfileViewModel.refresh failed: \(error)")
        }
    }
}
