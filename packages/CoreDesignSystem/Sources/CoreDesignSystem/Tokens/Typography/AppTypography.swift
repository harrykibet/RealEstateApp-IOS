//
//  Typography.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//

import SwiftUI


public struct AppTypography {

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
    
    public let display: Font
    public let label: Font
    public let button: Font
    
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
        caption2: Font,
        display: Font,
        label: Font,
        button: Font
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
        self.display = display
        self.label = label
        self.button = button
    }
}

public extension AppTypography {
    static var estatia: AppTypography {
        AppTypography(
            largeTitle: .largeTitle,
            title1: .title,
            title2: .title2,
            title3: .title3,
            headline: .headline,
            body: .body,
            callout: .callout,
            subheadline: .subheadline,
            footnote: .footnote,
            caption: .caption,
            caption2: .caption2,
            display: 
        )
    }
}
