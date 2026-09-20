//
//  StreamingPipeline.swift
//  CorePlayerEngine
//
//  Created by builder on 9/20/26.
//


public protocol StreamingPipeline: Sendable {

    func warm(
        mediaId: String,
        source: MediaSource,
        priority: WarmPriority
    ) async
}