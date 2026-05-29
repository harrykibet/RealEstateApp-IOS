//
//  AuthSession.swift
//  CoreModel
//
//  Created by builder on 5/29/26.
//

import Foundation

public enum AuthSession: Sendable, Equatable {

    // MARK: - No Active Session

    case unauthenticated

    // MARK: - Active Session

    case authenticated(
        user: User,
        status: AuthStatus
    )

    // MARK: - Init

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

    func updatingStatus(
        _ status: AuthStatus
    ) -> AuthSession {

        AuthSession(
            user: user,
            status: status
        )
    }
}
