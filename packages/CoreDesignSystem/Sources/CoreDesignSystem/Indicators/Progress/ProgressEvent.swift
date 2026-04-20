//
//  ProgressEvent.swift
//  CoreDesignSystem
//
//  Created by builder on 4/20/26.
//


public enum ProgressEvent: Sendable {
    
    case startIndeterminate
    
    case startDeterminate
    
    case updateProgress(Double)
    
    case updateBuffered(progress: Double, buffer: Double)
    
    case complete
    
    case fail(Error?)
    
    case reset
}