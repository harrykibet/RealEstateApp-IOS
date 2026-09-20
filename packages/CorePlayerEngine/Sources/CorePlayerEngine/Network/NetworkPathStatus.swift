//
//  NetworkPathStatus.swift
//  CorePlayerEngine
//
//  Created by builder on 9/20/26.
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

    var snapshots: AsyncStream<NetworkSnapshot> { get }

    func start()

    func stop()
}

@MainActor
public final class NetworkConnectivityMonitor:
    NetworkConnectivityProviding {

    // MARK: - Dependencies

    private let monitor: NWPathMonitor
    private let queue: DispatchQueue

    // MARK: - Stream

    public let snapshots: AsyncStream<NetworkSnapshot>

    private let continuation:
        AsyncStream<NetworkSnapshot>.Continuation

    // MARK: - State

    public private(set) var currentSnapshot:
        NetworkSnapshot = NetworkSnapshot(
            status: .unknown
        )

    private var isStarted = false

    // MARK: - Init

    public init(
        monitor: NWPathMonitor = NWPathMonitor(),
        queue: DispatchQueue = DispatchQueue(
            label: "com.estatia.coreplayerengine.network-monitor",
            qos: .utility
        )
    ) {
        self.monitor = monitor
        self.queue = queue

        let stream = AsyncStream<NetworkSnapshot>.makeStream()

        self.snapshots = stream.stream
        self.continuation = stream.continuation
    }

    // MARK: - Lifecycle

    public func start() {

        guard !isStarted else {
            return
        }

        isStarted = true

        monitor.pathUpdateHandler =  {  [weak self] path in

            let snapshot =  Self.snapshot(
                from: path
            )

            Task { @MainActor [weak self] in

                guard let self else {
                    return
                }

                self.publish(snapshot)
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

        monitor.cancel()

        continuation.finish()
    }

    // MARK: - Internal

    private func publish(
        _ snapshot: NetworkSnapshot
    ) {

        guard snapshot != currentSnapshot else {
            return
        }

        currentSnapshot = snapshot

        continuation.yield(
            snapshot
        )
    }

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
