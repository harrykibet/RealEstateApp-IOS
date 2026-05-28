//
//  AuthStatus.swift
//  CoreModel
//
//  Created by builder on 5/28/26.
//


import Foundation

public enum AuthStatus: Sendable, Equatable {

    case authenticated

    case unauthenticated

    case pendingVerification(VerificationType)

    case restricted(Reason)
}
