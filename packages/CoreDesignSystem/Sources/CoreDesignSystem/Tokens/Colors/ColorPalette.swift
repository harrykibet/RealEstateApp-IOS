//
//  ColorPalette.swift
//  CoreDesignSystem
//
//  Created by builder on 4/1/26.
//

import SwiftUI

@available(iOS 13.0, *)
public enum ColorPalette {
    
    public enum Blue {
        public static let deep = Color(hex: "#1E3A8A")
        public static let strong = Color(hex: "#1D4ED8")
        public static let base = Color(hex: "#3B82F6")
    }
    
    public enum Green {
        public static let base = Color(hex: "#10B981")
        public static let strong = Color(hex: "#059669")
    }
    
    public enum Gray {
        public static let ultraLight = Color(hex: "#F9FAFB")
        public static let light = Color(hex: "#F3F4F6")
        public static let medium = Color(hex: "#9CA3AF")
        public static let secondary = Color(hex: "#6B7280")
        public static let primary = Color(hex: "#111827")
    }
    
    public enum Base {
        public static let white = Color(hex: "#FFFFFF")
        public static let black = Color(hex: "#000000")
    }
    
    public enum Status {
        public static let error = Color(hex: "#EF4444")
        public static let warning = Color(hex: "#F59E0B")
        public static let success = Color(hex: "#22C55E")
        public static let info = Color(hex: "#3B82F6")
    }
}
