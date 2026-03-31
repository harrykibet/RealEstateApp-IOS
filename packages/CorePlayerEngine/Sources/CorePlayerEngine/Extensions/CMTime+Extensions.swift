//
//  CMTime+Extensions.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation
import AVFoundation

// MARK: - CMTime Extensions

public extension CMTime {
    
    /// Safe conversion to seconds.
    /// Returns 0 if invalid or indefinite.
    var safeSeconds: TimeInterval {
        guard isValid, isNumeric, !seconds.isNaN, seconds.isFinite else {
            return 0
        }
        return seconds
    }
    
    /// Whether the time is usable for playback calculations.
    var isUsable: Bool {
        isValid && isNumeric && seconds.isFinite
    }
    
    /// Convenience initializer for seconds with standard timescale.
    static func from(seconds: TimeInterval) -> CMTime {
        CMTime(seconds: seconds, preferredTimescale: 600)
    }
}
