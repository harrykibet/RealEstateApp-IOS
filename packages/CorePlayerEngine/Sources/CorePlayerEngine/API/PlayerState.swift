//
//  PlayerState.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

public enum PlayerState: Equatable, Sendable {

    case idle
    case loading
    case ready
    case playing
    case paused
    case buffering
    case reconnecting
    case ended
    case error(PlayerError)
}

public extension PlayerState {

    var isPlayable: Bool {
        switch self {
        case .ready, .paused, .ended:
            return true

        default:
            return false
        }
    }

    var isSeekable: Bool {
        switch self {
        case .ready, .playing, .paused, .buffering, .reconnecting:
            return true

        default:
            return false
        }
    }

    var isTerminal: Bool {
        switch self {
        case .error:
            return true

        default:
            return false
        }
    }
}
