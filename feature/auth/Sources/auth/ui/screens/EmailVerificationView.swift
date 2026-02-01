//
//  EmailVerificationView.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import SwiftUI

public struct EmailVerificationView: View {

    @StateObject private var viewModel: EmailVerificationViewModel

    public init(viewModel: EmailVerificationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 16) {

            Text("Verify Email")
                .font(.title.bold())

            Text("Check your inbox and verify your email address.")
                .multilineTextAlignment(.center)

            if let message = viewModel.message {
                Text(message).foregroundColor(.green)
            }

            Button {
                Task { await viewModel.resendEmail() }
            } label: {
                Group {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Resend Email")
                        }
                    }            }
            .buttonStyle(.bordered)

            Button("I’ve Verified My Email") {
                viewModel.emailVerified()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
