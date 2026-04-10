//
//  Color+Extensions.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

@available(iOS 13.0, *)
public extension Color {
    
    init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&value)

        let a, r, g, b: UInt64
        
        switch sanitized.count {
        case 6:
            (a, r, g, b) = (255, value >> 16, (value >> 8) & 0xFF, value & 0xFF)
        case 8:
            (a, r, g, b) = (value >> 24, (value >> 16) & 0xFF, (value >> 8) & 0xFF, value & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
