import Foundation
import CoreModel
import FirebaseAuth

public actor FirebaseAuthRemoteDataSource: AuthRemoteDataSource {
    
    public init() {}
    
    public func signIn(
        email: String,
        password: String
    ) async throws -> AuthSession {

        let result = try await Auth.auth().signIn(
            withEmail: email,
            password: password
        )

        return mapAuthSession(from: result.user)
    }
    
    public func signUp(
        email: String,
        password: String,
        displayName: String?
    ) async throws -> AuthSession {

        let result = try await Auth.auth().createUser(
            withEmail: email,
            password: password
        )

        if let displayName, !displayName.isEmpty {
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()
        }

        return mapAuthSession(from: result.user)
    }
    
    public func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    public func currentSession() async throws -> AuthSession {

        guard let firebaseUser = Auth.auth().currentUser else {
            return .unauthenticated
        }

        return mapAuthSession(
            from: firebaseUser
        )
    }
    
    private func mapAuthSession(
        from user: FirebaseAuth.User
    ) -> AuthSession {

        let appUser = mapFirebaseUser(user)

        let status: AuthStatus

        if user.isEmailVerified {
            status = .authenticated
        } else {
            status = .pendingVerification(.email)
        }

        return AuthSession(
            user: appUser,
            status: status
        )
    }
    
    private func mapFirebaseUser(
        _ user: FirebaseAuth.User
    ) -> CoreModel.User {
        
        User(
            userId: user.uid,
            name: user.displayName,
            email: user.email,
            phoneNumber: user.phoneNumber,
            profilePictureUrl: user.photoURL?.absoluteString,
            userType: .tenant,
            likedProperties: []
        )
    }
}
