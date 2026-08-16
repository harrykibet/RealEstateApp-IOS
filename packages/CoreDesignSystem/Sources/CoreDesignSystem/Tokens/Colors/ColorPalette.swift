//
//  ColorPalette.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

public enum ColorPalette {
    
    public enum Blue {
        // Estatia primary blue tokens
        public static let base = Color(hex: "#1A73E8") // Primary Estatia Blue
        public static let deep = Color(hex: "#1A73E8")
        public static let strong = Color(hex: "#1A73E8")
    }
    
    public enum Green {
        public static let base = Color(hex: "#10B981")
        public static let strong = Color(hex: "#059669")
    }
    
    public enum Gray {
        // Adjusted greys to Estatia slate scale
        public static let ultraLight = Color(hex: "#F8F9FA") // Background (Light)
        public static let light = Color(hex: "#F3F4F6")
        public static let medium = Color(hex: "#9CA3AF")
        public static let secondary = Color(hex: "#6B7280")
        public static let primary = Color(hex: "#121212") // Avoid pure black
    }
    
    public enum Base {
        // Use Estatia background tokens instead of pure black/white
        public static let white = Color(hex: "#F8F9FA")
        public static let black = Color(hex: "#121212")
    }
    
    public enum Status {
        public static let error = Color(hex: "#D93025")
        public static let warning = Color(hex: "#F9AB00")
        public static let success = Color(hex: "#1E8E3E")
        public static let info = Color(hex: "#1A73E8")
    }
}
