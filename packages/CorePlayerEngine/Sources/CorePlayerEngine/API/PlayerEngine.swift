//
//  PlayerEngine.swift
//  CorePlayerEngine
//

import Foundation

@MainActor
public protocol PlayerEngine: AnyObject {

    // MARK: - Lifecycle

    func load(_ source: MediaSource) async throws

    func play() async throws

    func pause() async throws

    func seek(to seconds: TimeInterval) async throws

    func stop() async throws

    func release() async throws

    // MARK: - State

    var state: AsyncStream<PlayerState> { get }

    var events: AsyncStream<PlayerEvent> { get }

    // MARK: - Observability

    var currentTime: TimeInterval { get async }

    var duration: TimeInterval? { get async }
}
