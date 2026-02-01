//
//  AnalyticsEvent.swift
//  model
//
//  Created by builder on 5/3/25.
//


import Foundation

struct AnalyticsEvent {
    var eventId: String
    var eventType: String
    var userId: String
    var timestamp: Int64
    var metadata: [String: String]
    var deviceInfo: DeviceInfo
    var userLocation: UserLocation?
}
