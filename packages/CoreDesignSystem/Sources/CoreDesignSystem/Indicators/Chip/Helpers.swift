//
//  Preview+Helpers.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//

import SwiftUI

// MARK: - Helpers

func section<Content: View>(
    title: String,
    @ViewBuilder content: () -> Content
) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        EstatiaText(title, style: .subtitle)
        content()
    }
}

var filterOptions: [EstatiaChipItem] {
    [
        .init(id: "1", title: "1 Bedroom"),
        .init(id: "2", title: "2 Bedroom"),
        .init(id: "3", title: "3 Bedroom"),
        .init(id: "4", title: "Furnished"),
        .init(id: "5", title: "Unfurnished"),
        .init(id: "6", title: "Pet Friendly")
    ]
}
