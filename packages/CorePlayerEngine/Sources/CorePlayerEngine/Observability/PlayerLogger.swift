//
//  PlayerLogger.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

/// Centralized logging utility for the player engine.
///
/// Goals:
/// - Structured logs (not random print statements)
/// - Easy to disable in production
/// - Extendable for remote logging later
///
/// Logging is controlled via `PlayerConfiguration.enableLogging`.
public final class PlayerLogger {
    
    public enum Level: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARN"
        case error = "ERROR"
    }
    
    private let isEnabled: Bool
    
    public init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    public func log(
        _ message: @autoclosure () -> String,
        level: Level = .debug,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard isEnabled else { return }
        
        let filename = (file as NSString).lastPathComponent
        
        print("[Player][\(level.rawValue)] \(filename):\(line) \(function) → \(message())")
    }
}
