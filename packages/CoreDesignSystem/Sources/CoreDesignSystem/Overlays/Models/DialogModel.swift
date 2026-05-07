//
//  DialogModel.swift
//  CoreDesignSystem
//
//  Created by builder on 5/7/26.
//

import Foundation

public struct DialogModel: Identifiable, Sendable {

    public struct Action: Identifiable, Sendable {

        public enum Role: Sendable {
            case normal
            case cancel
            case destructive
        }

        public let id: UUID
        public let title: String
        public let role: Role
        public let handler: @Sendable () -> Void

        public init(
            id: UUID = UUID(),
            title: String,
            role: Role = .normal,
            handler: @escaping @Sendable () -> Void
        ) {
            self.id = id
            self.title = title
            self.role = role
            self.handler = handler
        }
    }

    public let id: OverlayID
    public let title: String
    public let message: String?
    public let actions: [Action]

    public init(
        id: OverlayID = OverlayID(),
        title: String,
        message: String? = nil,
        actions: [Action]
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.actions = actions
    }
}
