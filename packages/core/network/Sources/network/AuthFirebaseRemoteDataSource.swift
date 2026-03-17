import Foundation
import model

#if canImport(FirebaseAuth)
import FirebaseAuth

public final class FirebaseAuthRemoteDataSource: AuthRemoteDataSource {
    public init() {}

    public func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return mapUser(result.user)
    }

    public func signUp(email: String, password: String, displayName: String?) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        if let displayName, !displayName.isEmpty {
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()
        }
        return mapUser(result.user)
    }

    public func signOut() async throws {
        try Auth.auth().signOut()
    }

    public func currentUser() async throws -> User? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        return mapUser(user)
    }

    private func mapUser(_ user: FirebaseAuth.User) -> User {
        User(
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
#endif
