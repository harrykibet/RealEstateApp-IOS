//
//  AuthStatus.swift
//  CoreModel
//
//  Created by builder on 5/29/26.
//

import Foundation

public enum AuthStatus: Sendable, Equatable {

    // MARK: - Fully Authenticated

    case authenticated

    // MARK: - Additional Steps Required

    case pendingVerification(
        VerificationType
    )

    // MARK: - Restricted Access

    case restricted(
        Reason
    )
}
