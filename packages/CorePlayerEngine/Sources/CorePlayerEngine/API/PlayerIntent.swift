//
//  PlayerIntent.swift
//  CorePlayerEngine
//
//  Created by builder on 3/28/26.
//

import Foundation


private enum PlayerIntent {
    case load(MediaSource)
    case play
    case pause
    case seek(TimeInterval)
    case stop
    case release
    
    // Internal (from AVPlayerWrapper)
    case ready
    case buffering(Bool)
    case completed
    case failed(Error)
    case progress(PlaybackProgress)
}
