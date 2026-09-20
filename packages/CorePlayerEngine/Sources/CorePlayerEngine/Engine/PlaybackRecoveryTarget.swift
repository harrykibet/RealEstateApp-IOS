//
//  PlaybackRecoveryTarget.swift
//  CorePlayerEngine
//
//  Created by builder on 9/20/26.
//


@MainActor
public protocol PlaybackRecoveryTarget: AnyObject {

    var activeMediaId: String? { get }

    func markNetworkUnavailable() async

    func isActiveMediaReconnecting() async -> Bool

    func recoverActivePlayback() async throws

    func failActiveRecovery() async
}