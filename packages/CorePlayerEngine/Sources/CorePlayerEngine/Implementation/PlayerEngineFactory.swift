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
    
public enum PlayerEngineFactory {
    
    /// Creates a default player engine instance.
    ///
    /// - Parameter config: Player configuration
    /// - Returns: Fully wired PlayerEngine
    public static func make(
        config: PlayerConfiguration = PlayerConfiguration()
    ) -> PlayerEngine {
        
        let loader = AVPlayerLoader()

        let wrapper = AVPlayerWrapper(
            progressInterval: config.progressUpdateInterval,
            loader: loader
        )

        let engine = DefaultPlayerEngine(
            config: config,
            player: wrapper
        )

        return engine
    }
}
