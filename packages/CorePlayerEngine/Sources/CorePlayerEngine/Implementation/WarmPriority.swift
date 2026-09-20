//
//  WarmPriority.swift
//  CorePlayerEngine
//
//  Created by builder on 9/20/26.
//


public enum WarmPriority: Int, Sendable {
    case speculative = 0
    case previous = 1
    case next = 2
    case visible = 3
}