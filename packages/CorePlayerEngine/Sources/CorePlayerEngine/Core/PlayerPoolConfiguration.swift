//
//  PlayerPoolConfiguration.swift
//  CorePlayerEngine
//
//  Created by builder on 9/18/26.
//


import Foundation

public struct PlayerPoolConfiguration: Equatable, Sendable {

    /// Maximum number of retained player instances, active + idle.
    public let maxPlayers: Int

    /// Maximum number of idle player instances retained for reuse.
    public let maxIdlePlayers: Int

    public init(
        maxPlayers: Int = 3,
        maxIdlePlayers: Int = 2
    ) {
        precondition(maxPlayers > 0, "maxPlayers must be greater than zero")
        precondition(
            maxIdlePlayers >= 0,
            "maxIdlePlayers cannot be negative"
        )
        precondition(
            maxIdlePlayers <= maxPlayers,
            "maxIdlePlayers cannot exceed maxPlayers"
        )

        self.maxPlayers = maxPlayers
        self.maxIdlePlayers = maxIdlePlayers
    }
}