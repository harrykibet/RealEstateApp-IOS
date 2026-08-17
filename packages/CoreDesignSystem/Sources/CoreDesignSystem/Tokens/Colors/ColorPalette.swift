//
//  ColorPalette.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//
//  Raw palette tokens aligned with Android core/design-system/theme/Color.kt

import SwiftUI

public enum ColorPalette {

    // MARK: - Trust Blue (Primary)

    public enum Blue {
        public static let blue10 = Color(hex: "#001945")
        public static let blue20 = Color(hex: "#00308F")
        public static let blue30 = Color(hex: "#0047AB")
        public static let blue40 = Color(hex: "#1A73E8") // Main primary
        public static let blue80 = Color(hex: "#D2E3FC")
        public static let blue90 = Color(hex: "#E8F0FE")

        /// Legacy alias
        public static let base = blue40
    }

    // MARK: - Slate Grays (Neutrals)

    public enum Slate {
        public static let slate10 = Color(hex: "#121212") // Dark background
        public static let slate20 = Color(hex: "#202124") // Dark surface / inverse
        public static let slate30 = Color(hex: "#3C4043")
        public static let slate40 = Color(hex: "#5F6368")
        public static let slate50 = Color(hex: "#80868B")
        public static let slate60 = Color(hex: "#9AA0A6")
        public static let slate70 = Color(hex: "#BDC1C6")
        public static let slate80 = Color(hex: "#DADCE0") // Outline (light)
        public static let slate90 = Color(hex: "#E8EAED") // Light surface variant
        public static let slate95 = Color(hex: "#F1F3F4")
        public static let slate99 = Color(hex: "#F8F9FA") // Pure background (light)
    }

    // MARK: - Red (Error)

    public enum Red {
        public static let red10 = Color(hex: "#410002")
        public static let red20 = Color(hex: "#690005")
        public static let red30 = Color(hex: "#93000A")
        public static let red40 = Color(hex: "#D93025") // Error (light)
        public static let red80 = Color(hex: "#FAD2CF") // Error (dark)
        public static let red90 = Color(hex: "#FCE8E6")
    }

    // MARK: - Green (Success)

    public enum Green {
        public static let green10 = Color(hex: "#00210B")
        public static let green20 = Color(hex: "#003919")
        public static let green30 = Color(hex: "#005227")
        public static let green40 = Color(hex: "#1E8E3E") // Success
        public static let green80 = Color(hex: "#CEEAD6")
        public static let green90 = Color(hex: "#E6F4EA")
    }

    // MARK: - Orange (Warning / Tertiary)

    public enum Orange {
        public static let orange10 = Color(hex: "#380D00")
        public static let orange20 = Color(hex: "#5B1A00")
        public static let orange30 = Color(hex: "#812800")
        public static let orange40 = Color(hex: "#F9AB00") // Warning
        public static let orange80 = Color(hex: "#FFE082")
        public static let orange90 = Color(hex: "#FFF8E1")
    }

    // MARK: - Base

    public enum Base {
        public static let white = Color(hex: "#FFFFFF")
        public static let black = Color(hex: "#121212")
    }
}
