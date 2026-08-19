import Foundation

// Domain exception marker
public protocol DomainException: Error {}

// Infrastructure exception marker
public protocol InfrastructureException: Error {}

// Marker protocols for infra exceptions that should NOT be translated by generic mappers
public protocol InfrastructureAuthException: InfrastructureException {}
public protocol InfrastructureNetworkException: InfrastructureException {}

// Common domain-level exceptions used across the app
public enum DomainError: Error, LocalizedError, Equatable, DomainException {
    case unknown(String?)
    case notFound(String?)
    case conflict(String?)
    case databaseCorrupted(String?)
    case validation(String?)
    case unauthenticated
    case unauthorized
    case forbidden

    public var errorDescription: String? {
        switch self {
        case .unknown(let msg): return msg ?? "An unknown error occurred"
        case .notFound(let msg): return msg ?? "Requested resource was not found"
        case .conflict(let msg): return msg ?? "Conflict"
        case .databaseCorrupted(let msg): return msg ?? "Database is corrupted"
        case .validation(let msg): return msg ?? "Validation failed"
        case .unauthenticated: return "Unauthenticated"
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Forbidden"
        }
    }
}

// A small helper mapper protocol to translate infrastructure errors into domain errors.
// Implementations can provide custom translation logic. The default implementation
// below maps unknown infra errors to DomainError. It will pass through any error that
// already conforms to DomainException or to the two infra marker protocols for auth and network.
public protocol InfrastructureToDomainExceptionMapper {
    static func map(_ error: Error) -> Error
}

public enum DefaultInfrastructureToDomainExceptionMapper: InfrastructureToDomainExceptionMapper {
    public static func map(_ error: Error) -> Error {
        // If already a domain-level exception, keep it
        if error is DomainException {
            return error
        }

        // If this is an infra auth or infra network exception, do not translate here — pass through
        if error is InfrastructureAuthException || error is InfrastructureNetworkException {
            return error
        }

        // Map some Foundation/common errors to domain errors as reasonable
        if (error as NSError).domain == NSURLErrorDomain {
            return DomainError.unknown("Network error: \((error as NSError).localizedDescription)")
        }

        // Fallback to unknown
        return DomainError.unknown((error as NSError).localizedDescription)
    }
}
