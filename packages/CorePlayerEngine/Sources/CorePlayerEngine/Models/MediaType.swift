//
//  MediaType.swift
//  CorePlayerEngine
//
//  Created by builder on 3/27/26.
//


// MARK: - MediaType

public enum MediaType: Equatable, Sendable {
    
    /// Let the engine infer (based on URL / MIME)
    case auto
    
    /// Progressive MP4, MP3, etc.
    case progressive
    
    /// HTTP Live Streaming (m3u8)
    case hls
    
    /// MPEG-DASH (future support)
    case dash
    
    /// Local file (sandbox / device storage)
    case file
}