//
//  BottomSheetModel.swift
//  CoreDesignSystem
//
//  Created by builder on 5/7/26.
//

import Foundation

public struct BottomSheetModel: Identifiable, Sendable, Equatable {

    public enum Detent: Sendable, Equatable {
        case compact
        case medium
        case large
        case fraction(CGFloat)
    }

    public let id: OverlayID
    public let initialDetent: Detent
    public let allowsInteractiveDismiss: Bool
    public let showsGrabber: Bool

    public init(
        id: OverlayID = OverlayID(),
        initialDetent: Detent = .medium,
        allowsInteractiveDismiss: Bool = true,
        showsGrabber: Bool = true
    ) {
        self.id = id
        self.initialDetent = initialDetent
        self.allowsInteractiveDismiss = allowsInteractiveDismiss
        self.showsGrabber = showsGrabber
    }
}
