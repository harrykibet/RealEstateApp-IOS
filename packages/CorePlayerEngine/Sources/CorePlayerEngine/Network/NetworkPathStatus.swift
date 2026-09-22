//  NetworkPathStatus.swift
//  CorePlayerEngine
//

import Foundation
import Network

public enum NetworkPathStatus: Sendable, Equatable {
    case unknown
    case satisfied
    case unsatisfied
    case requiresConnection
}

public struct NetworkSnapshot: Sendable, Equatable {

    public let status: NetworkPathStatus
    public let isExpensive: Bool
    public let isConstrained: Bool

    public init(
        status: NetworkPathStatus,
        isExpensive: Bool = false,
        isConstrained: Bool = false
    ) {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
    }

    public var isConnected: Bool {
        status == .satisfied
    }
}

@MainActor
public protocol NetworkConnectivityProviding: AnyObject {

    var currentSnapshot: NetworkSnapshot { get }

    /// Stream belonging to the current monitoring session.
    ///
    /// Calling `stop()` finishes the current stream. The next `start()`
    /// creates a fresh stream.
    var snapshots: AsyncStream<NetworkSnapshot> { get }

    func start()

    func stop()
}

@MainActor
public final class NetworkConnectivityMonitor:
    NetworkConnectivityProviding {

    // MARK: - Dependencies

    private let makeMonitor:
        @MainActor () -> NWPathMonitor

    private let queue: DispatchQueue

    // MARK: - Runtime Monitor

    private var monitor: NWPathMonitor?

    // MARK: - Stream

    private var snapshotStream:
        AsyncStream<NetworkSnapshot>

    private var continuation:
        AsyncStream<NetworkSnapshot>.Continuation?

    public var snapshots:
        AsyncStream<NetworkSnapshot> {
        snapshotStream
    }

    // MARK: - State

    public private(set) var currentSnapshot:
        NetworkSnapshot = NetworkSnapshot(
            status: .unknown
        )

    private var isStarted = false

    // MARK: - Initialization

    public init(
        monitorFactory: @escaping @MainActor () -> NWPathMonitor = {
            NWPathMonitor()
        },
        queue: DispatchQueue = DispatchQueue(
            label: "com.estatia.coreplayerengine.network-monitor",
            qos: .utility
        )
    ) {
        self.makeMonitor = monitorFactory
        self.queue = queue

        let stream =
            AsyncStream<NetworkSnapshot>.makeStream()

        self.snapshotStream =
            stream.stream

        self.continuation =
            stream.continuation
    }

    // MARK: - Lifecycle

    public func start() {

        guard !isStarted else {
            return
        }

        isStarted = true

        // Every monitoring session gets a fresh stream.
        let stream =
            AsyncStream<NetworkSnapshot>.makeStream()

        snapshotStream =
            stream.stream

        continuation =
            stream.continuation

        currentSnapshot =
            NetworkSnapshot(
                status: .unknown
            )

        let monitor =
            makeMonitor()

        self.monitor = monitor

        monitor.pathUpdateHandler =
            { [weak self] path in

                let snapshot =
                    Self.snapshot(
                        from: path
                    )

                Task { @MainActor [weak self] in

                    guard let self else {
                        return
                    }

                    self.publish(
                        snapshot
                    )
                }
            }

        monitor.start(
            queue: queue
        )
    }

    public func stop() {

        guard isStarted else {
            return
        }

        isStarted = false

        monitor?.cancel()
        monitor = nil

        continuation?.finish()
        continuation = nil

        currentSnapshot =
            NetworkSnapshot(
                status: .unknown
            )
    }

    // MARK: - Publishing

    private func publish(
        _ snapshot: NetworkSnapshot
    ) {

        guard snapshot != currentSnapshot else {
            return
        }

        currentSnapshot =
            snapshot

        continuation?.yield(
            snapshot
        )
    }

    // MARK: - Mapping

    private static func snapshot(
        from path: NWPath
    ) -> NetworkSnapshot {

        let status: NetworkPathStatus

        switch path.status {

        case .satisfied:
            status = .satisfied

        case .unsatisfied:
            status = .unsatisfied

        case .requiresConnection:
            status = .requiresConnection

        @unknown default:
            status = .unknown
        }

        return NetworkSnapshot(
            status: status,
            isExpensive: path.isExpensive,
            isConstrained: path.isConstrained
        )
    }
}
