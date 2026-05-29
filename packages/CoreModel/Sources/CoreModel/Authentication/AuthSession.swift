//
//  AuthSession.swift
//  CoreModel
//
//  Created by builder on 5/29/26.
//

import Foundation

public enum AuthSession: Sendable, Equatable {

    case unauthenticated

    case authenticated(
        user: User,
        status: AuthStatus
    )

    public init(
        user: User,
        status: AuthStatus
    ) {
        self = .authenticated(
            user: user,
            status: status
        )
    }
}

public extension AuthSession {

    var user: User? {
        guard case let .authenticated(user, _) = self else {
            return nil
        }

        return user
    }

    var status: AuthStatus? {
        guard case let .authenticated(_, status) = self else {
            return nil
        }

        return status
    }

    var isAuthenticated: Bool {
        if case .authenticated = self {
            return true
        }

        return false
    }
}

public extension AuthSession {

    func updatingStatus(
        _ status: AuthStatus
    ) -> AuthSession {

        AuthSession(
            user: user,
            status: status
        )
    }
}
