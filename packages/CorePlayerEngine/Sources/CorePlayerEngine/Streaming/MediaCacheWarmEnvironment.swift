//
//  MediaCacheWarmEnvironment.swift
//  CorePlayerEngine
//
//  Created by builder on 9/23/26.
//


//
//  MediaCacheSizingPolicy.swift
//  CorePlayerEngine
//

import Foundation

public struct MediaCacheWarmEnvironment:
    Sendable,
    Equatable {

    public let isMetered: Bool
    public let isConstrained: Bool
    public let isLowPowerMode: Bool
    public let estimatedThroughputBps: Int64?

    public init(
        isMetered: Bool = false,
        isConstrained: Bool = false,
        isLowPowerMode: Bool = false,
        estimatedThroughputBps: Int64? = nil
    ) {
        self.isMetered = isMetered
        self.isConstrained = isConstrained
        self.isLowPowerMode = isLowPowerMode
        self.estimatedThroughputBps =
            estimatedThroughputBps
    }
}

public struct MediaCacheSizingPolicy:
    Sendable,
    Equatable {

    public let visibleBytes: Int64
    public let nextBytes: Int64
    public let previousBytes: Int64
    public let speculativeBytes: Int64

    /// Size of each disk cache chunk.
    public let chunkBytes: Int

    /// Maximum aggregate disk usage.
    public let maximumCacheBytes: Int64

    public init(
        visibleBytes: Int64 = 4 * 1024 * 1024,
        nextBytes: Int64 = 2 * 1024 * 1024,
        previousBytes: Int64 = 1 * 1024 * 1024,
        speculativeBytes: Int64 = 512 * 1024,
        chunkBytes: Int = 512 * 1024,
        maximumCacheBytes: Int64 =
            128 * 1024 * 1024
    ) {
        precondition(
            visibleBytes > 0
        )

        precondition(
            nextBytes > 0
        )

        precondition(
            previousBytes > 0
        )

        precondition(
            speculativeBytes > 0
        )

        precondition(
            chunkBytes > 0
        )

        precondition(
            maximumCacheBytes >= chunkBytes
        )

        self.visibleBytes = visibleBytes
        self.nextBytes = nextBytes
        self.previousBytes = previousBytes
        self.speculativeBytes = speculativeBytes
        self.chunkBytes = chunkBytes
        self.maximumCacheBytes =
            maximumCacheBytes
    }

    public func budget(
        for priority: WarmPriority,
        environment:
            MediaCacheWarmEnvironment
    ) -> Int64 {

        let base: Int64

        switch priority {

        case .visible:
            base = visibleBytes

        case .next:
            base = nextBytes

        case .previous:
            base = previousBytes

        case .speculative:
            base = speculativeBytes
        }

        var multiplier = 1.0

        if environment.isConstrained {
            multiplier *= 0.25
        } else if environment.isMetered {
            multiplier *= 0.5
        }

        if environment.isLowPowerMode {
            multiplier *= 0.5
        }

        if let throughput =
            environment.estimatedThroughputBps,
           throughput < 1_000_000 {

            multiplier *= 0.5
        }

        let calculated =
            Int64(
                Double(base) *
                multiplier
            )

        return max(
            Int64(chunkBytes),
            calculated
        )
    }
}