//
//  ForgotPasswordView.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import SwiftUI

public struct ForgotPasswordView: View {

    // MARK: - Properties

    @ObservedObject
    private var viewModel: ForgotPasswordViewModel

    private let onBackToLogin: () -> Void

    // MARK: - Init

    public init(
        viewModel: ForgotPasswordViewModel,
        onBackToLogin: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onBackToLogin = onBackToLogin
    }

    // MARK: - Body

    public var body: some View {

        VStack(spacing: 16) {

            Text("Reset Password")
                .font(.title.bold())

            TextField(
                "Email",
                text: $viewModel.form.email
            )
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .textFieldStyle(.roundedBorder)

            if let error = viewModel.uiState.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            if let success = viewModel.uiState.successMessage {
                Text(success)
                    .foregroundColor(.green)
            }

            Button {
                Task {
                    await viewModel.sendResetLink()
                }
            } label: {

                if viewModel.uiState.isLoading {
                    ProgressView()
                } else {
                    Text("Send Reset Link")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.uiState.isLoading)

            Button("Back to Login") {
                onBackToLogin()
            }
            .font(.caption)
        }
        .padding()
    }
}
