//
//  SocialLoginButton.swift
//  FeatureAuth
//
//  Created by builder on 6/12/26.
//

import SwiftUI

public struct SocialLoginButton: View {

    public enum Provider {
        case apple
        case google
    }

    private let provider: Provider
    private let action: () -> Void

    public init(
        provider: Provider,
        action: @escaping () -> Void
    ) {
        self.provider = provider
        self.action = action
    }

    public var body: some View {

        Button(action: action) {

            HStack(spacing: 12) {

                icon

                Text(title)
                    .font(.system(size: 16, weight: .semibold))

                Spacer()
            }
        }
        .buttonStyle(SocialButtonStyle(provider: provider))
    }

    private var icon: some View {
        Group {
            switch provider {

            case .apple:
                Image(systemName: "apple.logo")

            case .google:
                Image("google_logo") // asset catalog
            }
        }
    }

    private var title: String {
        switch provider {
        case .apple: return "Continue with Apple"
        case .google: return "Continue with Google"
        }
    }
} 
