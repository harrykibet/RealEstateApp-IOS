//
//  AuthFlowState.swift
//  FeatureAuth
//
//  Created by builder on 5/29/26.
//

import CoreModel

enum AuthFlowState: Sendable {

    case login

    case signup

    case forgotPassword

    case verification(VerificationType)
}
