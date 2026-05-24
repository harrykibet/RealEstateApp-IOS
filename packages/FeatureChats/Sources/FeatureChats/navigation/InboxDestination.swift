//
//  InboxDestination.swift
//  FeatureChats
//
//  Created by builder on 5/24/26.
//


public enum InboxDestination: Hashable, Sendable {
    case list
    case chat(id: String)
}