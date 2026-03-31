//
//  PlayerEngineFactory.swift
//  CorePlayerEngine
//
//  Created by builder on 3/26/26.
//

import Foundation

/// Factory responsible for creating fully configured PlayerEngine instances.
///
/// Why this exists:
/// - Centralizes dependency wiring
/// - Prevents incorrect initialization
/// - Makes swapping implementations easy (mock, test, etc.)
///
/// This is your equivalent of a DI entry point.
@available(iOS 13.0, *)
public enum PlayerEngineFactory {
    
    /// Creates a default player engine instance.
    ///
    /// - Parameter config: Player configuration
    /// - Returns: Fully wired PlayerEngine
    public static func make(
        config: PlayerConfiguration = .default
    ) -> PlayerEngine {
        
        let logger = PlayerLogger(isEnabled: config.enableLogging)
        let metrics = MetricsCollector()
        
        let loader = AVPlayerLoader()
        
        let wrapper = AVPlayerWrapper(
            progressInterval: config.progressUpdateInterval,
            loader: loader,
            logger: logger
        )
        
        let engine = DefaultPlayerEngine(
            config: config,
            player: wrapper,
            logger: logger,
            metrics: metrics
        )
        
        return engine
    }
}
