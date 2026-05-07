//
//  ToastModel.swift
//  CoreDesignSystem
//
//  Created by builder on 5/7/26.
//

import Foundation

public struct ToastModel: Identifiable, Sendable, Equatable {

    public enum Style: Sendable, Equatable {
        case info
        case success
        case warning
        case error
    }

    public let id: OverlayID
    public let title: String
    public let message: String?
    public let style: Style
    public let duration: Duration
    public let allowsManualDismiss: Bool

    public init(
        id: OverlayID = OverlayID(),
        title: String,
        message: String? = nil,
        style: Style = .info,
        duration: Duration = .seconds(3),
        allowsManualDismiss: Bool = true
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.style = style
        self.duration = duration
        self.allowsManualDismiss = allowsManualDismiss
    }
}
