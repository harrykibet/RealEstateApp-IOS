import Foundation
import CoreModel
import CoreNetwork

public protocol AuthRepository: Repository {
    
    func signIn(
        email: String,
        password: String
    ) async throws -> AuthSession
    
    func signUp(
        email: String,
        password: String,
        displayName: String?
    ) async throws -> AuthSession
    
    func sendEmailVerification() async throws
    
    public func sendEmailVerification() async throws {
        
    }
    
    public func sendPhoneVerificationCode() async throws {
        
    }
    
    public func sendPasswordResetEmail() async throws {
        
    }
    
    public func verifyPhoneCode(code: String) async throws {
        
    }
    func signOut() async throws
    
    func currentSession() async throws -> AuthSession
}

public actor RemoteAuthRepository: AuthRepository {
    
    public func sendEmailVerification() async throws {
        
    }
    
    public func sendPhoneVerificationCode() async throws {
        
    }
    
    public func sendPasswordResetEmail() async throws {
        
    }
    
    public func verifyPhoneCode(code: String) async throws {
        
    }
    
    private let remote: AuthRemoteDataSource
    
    public init(remote: AuthRemoteDataSource) {
        self.remote = remote
    }
    
    public func signIn(email: String, password: String) async throws -> AuthSession {
        try await remote.signIn(email: email, password: password)
    }
    
    public func signUp(email: String, password: String, displayName: String?) async throws -> AuthSession {
        try await remote.signUp(email: email, password: password, displayName: displayName)
    }
    
    public func signOut() async throws {
        try await remote.signOut()
    }
    
    public func currentSession() async throws -> AuthSession {
        try await remote.currentSession()
    }
}
