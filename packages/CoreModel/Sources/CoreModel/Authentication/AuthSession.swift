//
//  AuthSession.swift
//  CoreModel
//
//  Created by builder on 5/28/26.
//


import Foundation

public struct AuthSession: Sendable, Equatable {
    public let user: User
    public let status: AuthStatus

    public init(user: User, status: AuthStatus) {
        self.user = user
        self.status = status
    }
}
