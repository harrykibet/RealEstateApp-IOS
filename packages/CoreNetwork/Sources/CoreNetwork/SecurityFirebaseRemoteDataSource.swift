import Foundation
import CoreModel

#if canImport(FirebaseFirestore) && canImport(FirebaseFirestoreSwift)
import FirebaseFirestore
import FirebaseFirestoreSwift

public final class FirebaseSecurityRemoteDataSource: SecurityRemoteDataSource {
    private let db: Firestore
    private let collectionName: String
    private let documentId: String

    public init(
        db: Firestore = Firestore.firestore(),
        collectionName: String = "security",
        documentId: String = "config"
    ) {
        self.db = db
        self.collectionName = collectionName
        self.documentId = documentId
    }

    public func fetchSecurityConfig() async throws -> SecurityConfig {
        let snapshot = try await db.collection(collectionName).document(documentId).getDocument()
        return try snapshot.data(as: SecurityConfig.self)
    }

    public func updateSecurityConfig(_ config: SecurityConfig) async throws -> SecurityConfig {
        try db.collection(collectionName).document(documentId).setData(from: config, merge: true)
        return config
    }
}
#endif
