//
//  ForgotPasswordView.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import SwiftUI

public struct ForgotPasswordView: View {

    @ObservedObject
    private var viewModel: ForgotPasswordViewModel

    public init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 16) {

            Text("Reset Password")
                .font(.title.bold())

            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)

            if let error = viewModel.uiState.errorMessage {
                Text(error).foregroundColor(.red)
            }

            if let success = viewModel.uiState.successMessage {
                Text(success).foregroundColor(.green)
            }

            Button {
                Task { await viewModel.sendResetLink() }
            } label: {
                Group {
                    if viewModel.uiState.isLoading {
                            ProgressView()
                        } else {
                            Text("Send Reset Link")
                        }
                    }            }
            .buttonStyle(.borderedProminent)

            Button("Back to Login") {
                viewModel.backToLogin()
            }
            .font(.caption)
        }
        .padding()
    }
}

