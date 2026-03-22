import Foundation
import CoreModel

#if canImport(FirebaseFirestore) && canImport(FirebaseFirestoreSwift)
import FirebaseFirestore
import FirebaseFirestoreSwift

public final class FirebasePropertyRemoteDataSource: PropertyRemoteDataSource {
    private let db: Firestore
    private let collectionName: String

    public init(db: Firestore = Firestore.firestore(), collectionName: String = "properties") {
        self.db = db
        self.collectionName = collectionName
    }

    public func fetchProperty(id: String) async throws -> PropertyModel {
        let snapshot = try await db.collection(collectionName).document(id).getDocument()
        var property = try snapshot.data(as: PropertyModel.self)
        if property.id == nil {
            property.id = snapshot.documentID
        }
        return property
    }

    public func fetchProperties() async throws -> [PropertyModel] {
        let snapshot = try await db.collection(collectionName).getDocuments()
        return snapshot.documents.compactMap { document in
            var property = try? document.data(as: PropertyModel.self)
            if property?.id == nil {
                property?.id = document.documentID
            }
            return property
        }
    }

    public func searchProperties(query: String?, filters: PropertySearchFilters) async throws -> [PropertyModel] {
        var ref: Query = db.collection(collectionName)
        if let ownerId = filters.ownerId, !ownerId.isEmpty {
            ref = ref.whereField("ownerId", isEqualTo: ownerId)
        }
        if let county = filters.county, !county.isEmpty {
            ref = ref.whereField("county", isEqualTo: county)
        }
        if let propertyType = filters.propertyType, !propertyType.isEmpty {
            ref = ref.whereField("propertyType", isEqualTo: propertyType)
        }
        if let bedrooms = filters.bedrooms {
            ref = ref.whereField("bedrooms", isEqualTo: bedrooms)
        }
        if let bathrooms = filters.bathrooms {
            ref = ref.whereField("bathrooms", isEqualTo: bathrooms)
        }
        if let availableOnly = filters.availableOnly {
            ref = ref.whereField("available", isEqualTo: availableOnly)
        }
        if let minPrice = filters.minPrice {
            ref = ref.whereField("price", isGreaterThanOrEqualTo: minPrice)
        }
        if let maxPrice = filters.maxPrice {
            ref = ref.whereField("price", isLessThanOrEqualTo: maxPrice)
        }
        if let query, !query.isEmpty {
            ref = ref.order(by: "title")
                .whereField("title", isGreaterThanOrEqualTo: query)
                .whereField("title", isLessThanOrEqualTo: query + "\u{f8ff}")
        }

        let snapshot = try await ref.getDocuments()
        return snapshot.documents.compactMap { document in
            var property = try? document.data(as: PropertyModel.self)
            if property?.id == nil {
                property?.id = document.documentID
            }
            return property
        }
    }

    public func createProperty(_ property: PropertyModel) async throws -> PropertyModel {
        var mutable = property
        let doc = db.collection(collectionName).document(property.id ?? UUID().uuidString)
        try doc.setData(from: mutable, merge: true)
        if mutable.id == nil {
            mutable.id = doc.documentID
        }
        return mutable
    }

    public func updateProperty(_ property: PropertyModel) async throws -> PropertyModel {
        guard let propertyId = property.id, !propertyId.isEmpty else {
            throw RemoteDataSourceError.missingPropertyId
        }
        try db.collection(collectionName).document(propertyId).setData(from: property, merge: true)
        return property
    }

    public func deleteProperty(id: String) async throws {
        try await db.collection(collectionName).document(id).delete()
    }
}
#endif
