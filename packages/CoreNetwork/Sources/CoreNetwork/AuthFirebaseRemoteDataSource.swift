import Foundation
import CoreModel
import FirebaseAuth

public final class FirebaseAuthRemoteDataSource: AuthRemoteDataSource {

    public init() {}

    public func signIn(email: String, password: String) async throws -> CoreModel.User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return mapFirebaseUser(result.user)
    }

    public func signUp(email: String, password: String, displayName: String?) async throws -> CoreModel.User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)

        if let displayName, !displayName.isEmpty {
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()
        }

        return mapFirebaseUser(result.user)
    }

    public func signOut() async throws {
        try Auth.auth().signOut()
    }

    public func currentUser() async throws -> CoreModel.User? {
        guard let firebaseUser: FirebaseAuth.User = Auth.auth().currentUser else {
            return nil
        }
        return mapFirebaseUser(firebaseUser)
    }

    private func mapFirebaseUser(_ user: FirebaseAuth.User) -> CoreModel.User {
        CoreModel.User(
            userId: user.uid,
            name: user.displayName,
            email: user.email,
            phoneNumber: user.phoneNumber,
            profilePictureUrl: user.photoURL?.absoluteString,
            userType: .tenant,
            verified: user.isEmailVerified,
            likedProperties: []
        )
    }
}
