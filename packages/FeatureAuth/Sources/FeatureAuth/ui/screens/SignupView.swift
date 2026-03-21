//
//  SignupView.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import SwiftUI

public struct SignupView: View {

    @StateObject private var viewModel: SignupViewModel

    public init(viewModel: SignupViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 16) {

            Text("Create Account")
                .font(.largeTitle.bold())

            TextField("Email", text: $viewModel.form.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $viewModel.form.password)
                .textFieldStyle(.roundedBorder)

            SecureField("Confirm Password", text: $viewModel.form.confirmPassword)
                .textFieldStyle(.roundedBorder)

            if let error = viewModel.uiState.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button {
                Task { await viewModel.signup() }
            } label: {
                if viewModel.uiState.isLoading {
                    ProgressView()
                } else {
                    Text("Sign Up")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.uiState.isLoading)

            Button("Back to Login") {
                viewModel.backToLogin()
            }
            .font(.caption)
        }
        .padding()
    }
}
