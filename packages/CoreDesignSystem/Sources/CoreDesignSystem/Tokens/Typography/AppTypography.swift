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
    public let subtitle: Font
    
    public init(
        display: Font,
        title: Font,
        body: Font,
        label: Font,
        caption: Font,
        button: Font,
        subtitle: Font
    ) {
        self.display = display
        self.title = title
        self.body = body
        self.label = label
        self.caption = caption
        self.button = button
        self.subtitle = subtitle
    }
}

public extension AppTypography {
    static var estatia: AppTypography {
        AppTypography(
            display: .system(.largeTitle, design: .default),
            title: .system(.title3, design: .default),
            body: .system(.body),
            label: .system(.subheadline),
            caption: .system(.caption),
            button: .system(.body, weight: .semibold),
            subtitle: .system(.headline)
        )
    }
}
