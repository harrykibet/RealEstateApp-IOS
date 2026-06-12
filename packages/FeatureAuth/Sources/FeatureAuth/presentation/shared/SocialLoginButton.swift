//
//  SocialLoginButton.swift
//  FeatureAuth
//
//  Created by builder on 6/12/26.
//

import SwiftUI
import CoreDesignSystem

public struct SocialLoginButton: View {

    private let provider: Provider
    private let isLoading: Bool
    private let action: () -> Void

    public init(
        provider: Provider,
        isLoading: Bool,
        action: @escaping () -> Void
    ) {
        self.provider = provider
        self.isLoading = isLoading
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
                Image("google_logo",
                      bundle: .module)
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

#if DEBUG

#Preview("Social Login - Light") {
    Preview.light {
        socialLoginButtonPreviewContent
    }
}

#Preview("Social Login - Dark") {
    Preview.dark {
        socialLoginButtonPreviewContent
    }
}

// MARK: - Preview Content

private var socialLoginButtonPreviewContent: some View {

    VStack(spacing: 16) {

        SocialLoginButton(
            provider: .apple,
            isLoading: false,
            action: {}
        )

        SocialLoginButton(
            provider: .google,
            isLoading: false,
            action: {}
        )

        SocialLoginButton(
            provider: .apple,
            isLoading: true,
            action: {}
        )

        SocialLoginButton(
            provider: .google,
            isLoading: true,
            action: {}
        )
    }
    .padding()
}

#endif
