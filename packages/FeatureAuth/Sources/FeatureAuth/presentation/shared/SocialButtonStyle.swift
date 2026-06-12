//
//  SocialButtonStyle.swift
//  FeatureAuth
//
//  Created by builder on 6/12/26.
//


import SwiftUI

public struct SocialButtonStyle: ButtonStyle {
    
    public enum Provider {
        case apple
        case google
    }
    
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        
        HStack(spacing: 12) {
            
            configuration.label
                .foregroundStyle(foregroundColor)
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(background(configuration: configuration))
        .overlay(border)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .opacity(configuration.isPressed ? 0.92 : 1.0)
        .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        .accessibilityElement(children: .contain)
    }
    
    private func background(configuration: Configuration) -> some View {
        Group {
            switch provider {
                
            case .apple:
                Color.black.opacity(configuration.isPressed ? 0.85 : 1.0)
                
            case .google:
                Color.white.opacity(configuration.isPressed ? 0.85 : 1.0)
            }
        }
    }
    
    private var border: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .stroke(borderColor, lineWidth: 1)
    }
    
    private var borderColor: Color {
        switch provider {
        case .apple:
            return .clear
        case .google:
            return Color.gray.opacity(0.25)
        }
    }
    
    private var foregroundColor: Color {
        switch provider {
        case .apple:
            return .white
        case .google:
            return .primary
        }
    }
}
