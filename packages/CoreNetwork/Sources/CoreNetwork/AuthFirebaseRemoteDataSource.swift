import Foundation
import CoreModel
import FirebaseAuth

public final class FirebaseAuthRemoteDataSource: AuthRemoteDataSource {

    public init() {}

    public func signIn(
        email: String,
        password: String
    ) async throws -> AuthenticationResult {
        
        let result = try await Auth.auth().signIn(
            withEmail: email,
            password: password
        )
        
        return mapAuthenticationResult(
            from: result.user
        )
    }
    
    public func signUp(
        email: String,
        password: String,
        displayName: String?
    ) async throws -> AuthenticationResult {
        
        let result = try await Auth.auth().createUser(withEmail: email, password: password)

        if let displayName, !displayName.isEmpty {
            
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()
        }

        return mapAuthenticationResult(from: result.user)
    }

    public func signOut() async throws {
        try Auth.auth().signOut()
    }

    public func currentAuthenticationState()
    async throws -> AuthenticationState {
        
        guard let firebaseUser = Auth.auth().currentUser else {
            return .unauthenticated
        }
        
        let user = mapFirebaseUser(firebaseUser)
        
        if firebaseUser.isEmailVerified {
            return .authenticated(user)
        }
        
        return .requiresEmailVerification(user)
    }
    
    private func mapAuthenticationResult(
        from user: FirebaseAuth.User
    ) -> AuthenticationResult {
        
        if user.isEmailVerified {
            return .authenticated
        }
        
        return .requiresEmailVerification(
            email: user.email ?? ""
        )
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
