import Foundation
import model

#if canImport(FirebaseFirestore) && canImport(FirebaseFirestoreSwift)
import FirebaseFirestore
import FirebaseFirestoreSwift

public final class FirebaseUserRemoteDataSource: UserRemoteDataSource {
    private let db: Firestore
    private let collectionName: String

    public init(db: Firestore = Firestore.firestore(), collectionName: String = "users") {
        self.db = db
        self.collectionName = collectionName
    }

    public func fetchUser(id: String) async throws -> User {
        let snapshot = try await db.collection(collectionName).document(id).getDocument()
        return try snapshot.data(as: User.self)
    }

    public func updateUser(_ user: User) async throws -> User {
        guard let userId = user.userId, !userId.isEmpty else {
            throw RemoteDataSourceError.missingUserId
        }
        try db.collection(collectionName).document(userId).setData(from: user, merge: true)
        return user
    }

    public func deleteUser(id: String) async throws {
        try await db.collection(collectionName).document(id).delete()
    }

    public func fetchFavoritePropertyIds(userId: String) async throws -> [String] {
        let snapshot = try await db.collection(collectionName).document(userId).getDocument()
        let user = try snapshot.data(as: User.self)
        return user.likedProperties
    }

    public func addFavoriteProperty(userId: String, propertyId: String) async throws {
        try await db.collection(collectionName).document(userId).updateData([
            "likedProperties": FieldValue.arrayUnion([propertyId])
        ])
    }

    public func removeFavoriteProperty(userId: String, propertyId: String) async throws {
        try await db.collection(collectionName).document(userId).updateData([
            "likedProperties": FieldValue.arrayRemove([propertyId])
        ])
    }
}
#endif
