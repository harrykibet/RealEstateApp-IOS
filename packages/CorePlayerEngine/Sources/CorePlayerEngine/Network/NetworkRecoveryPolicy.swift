//
//  NetworkRecoveryPolicy.swift
//  CorePlayerEngine
//
//  Created by builder on 9/20/26.
//


import Foundation

public struct NetworkRecoveryPolicy: Sendable, Equatable {

    public let maximumAttempts: Int
    public let initialDelay: TimeInterval
    public let maximumDelay: TimeInterval
    public let backoffMultiplier: Double
    public let jitterRatio: Double

    public init(
        maximumAttempts: Int = 5,
        initialDelay: TimeInterval = 0.5,
        maximumDelay: TimeInterval = 8.0,
        backoffMultiplier: Double = 2.0,
        jitterRatio: Double = 0.2
    ) {
        precondition(
            maximumAttempts > 0,
            "maximumAttempts must be greater than zero."
        )

        precondition(
            initialDelay >= 0,
            "initialDelay cannot be negative."
        )

        precondition(
            maximumDelay >= initialDelay,
            "maximumDelay cannot be less than initialDelay."
        )

        precondition(
            backoffMultiplier >= 1,
            "backoffMultiplier must be at least 1."
        )

        precondition(
            jitterRatio >= 0 && jitterRatio <= 1,
            "jitterRatio must be between 0 and 1."
        )

        self.maximumAttempts = maximumAttempts
        self.initialDelay = initialDelay
        self.maximumDelay = maximumDelay
        self.backoffMultiplier = backoffMultiplier
        self.jitterRatio = jitterRatio
    }

    public func delay(
        forAttempt attempt: Int,
        randomFactor: Double = 0
    ) -> Duration {

        let exponent = pow(
            backoffMultiplier,
            Double(max(0, attempt))
        )

        let base = min(
            maximumDelay,
            initialDelay * exponent
        )

        let jitterMultiplier =
            1 +
            (randomFactor * jitterRatio)

        let finalDelay = max(
            0,
            min(
                maximumDelay,
                base * jitterMultiplier
            )
        )

        return .seconds(
            finalDelay
        )
    }
}
