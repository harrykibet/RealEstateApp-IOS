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

            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)

            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .textFieldStyle(.roundedBorder)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button {
                Task { await viewModel.signup() }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Sign Up")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)

            Button("Back to Login") {
                viewModel.backToLogin()
            }
            .font(.caption)
        }
        .padding()
    }
}
