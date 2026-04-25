//
//  Typography.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//

import SwiftUI

public struct AppTypography {
    public let display: Font
    public let title: Font
    public let body: Font
    public let label: Font
    public let caption: Font
    public let button: Font
    
    public init(
        display: Font,
        title: Font,
        body: Font,
        label: Font,
        caption: Font,
        button: Font
    ) {
        self.display = display
        self.title = title
        self.body = body
        self.label = label
        self.caption = caption
        self.button = button
    }
}

public extension AppTypography {
    static var estatia: AppTypography {
        AppTypography(
            display: .system(size: 32, weight: .bold),
            title: .system(size: 20, weight: .semibold),
            body: .system(size: 16, weight: .regular),
            label: .system(size: 14, weight: .medium),
            caption: .system(size: 12, weight: .regular),
            button: .system(size: 16, weight: .semibold)
        )
    }
}
