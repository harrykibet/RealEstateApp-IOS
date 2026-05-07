//
//  ModalModel.swift
//  CoreDesignSystem
//
//  Created by builder on 5/7/26.
//

import Foundation

public struct ModalModel: Identifiable, Sendable, Equatable {

    public let id: OverlayID
    public let title: String?
    public let dismissOnBackgroundTap: Bool
    public let allowsSwipeToDismiss: Bool

    public init(
        id: OverlayID = OverlayID(),
        title: String? = nil,
        dismissOnBackgroundTap: Bool = false,
        allowsSwipeToDismiss: Bool = true
    ) {
        self.id = id
        self.title = title
        self.dismissOnBackgroundTap = dismissOnBackgroundTap
        self.allowsSwipeToDismiss = allowsSwipeToDismiss
    }
}
