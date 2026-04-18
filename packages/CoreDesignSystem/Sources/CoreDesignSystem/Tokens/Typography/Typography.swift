//
//  Typography.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//

import SwiftUI


public struct Typography {

    public let largeTitle: Font
    public let title1: Font
    public let title2: Font
    public let title3: Font

    public let headline: Font
    public let body: Font
    public let callout: Font

    public let subheadline: Font
    public let footnote: Font
    public let caption: Font
    public let caption2: Font

    public init(
        largeTitle: Font,
        title1: Font,
        title2: Font,
        title3: Font,
        headline: Font,
        body: Font,
        callout: Font,
        subheadline: Font,
        footnote: Font,
        caption: Font,
        caption2: Font
    ) {
        self.largeTitle = largeTitle
        self.title1 = title1
        self.title2 = title2
        self.title3 = title3
        self.headline = headline
        self.body = body
        self.callout = callout
        self.subheadline = subheadline
        self.footnote = footnote
        self.caption = caption
        self.caption2 = caption2
    }
}

public extension Typography {

    static let estatia = Typography(
        largeTitle: .system(size: 34, weight: .bold),
        title1: .system(size: 28, weight: .bold),
        title2: .system(size: 22, weight: .semibold),
        title3: .system(size: 20, weight: .semibold),

        headline: .system(size: 17, weight: .semibold),
        body: .system(size: 17, weight: .regular),
        callout: .system(size: 16, weight: .regular),

        subheadline: .system(size: 15, weight: .regular),
        footnote: .system(size: 13, weight: .regular),
        caption: .system(size: 12, weight: .regular),
        caption2: .system(size: 11, weight: .regular)
    )
}
