//
//  ContentView.swift
//  auth
//
//  Created by builder on 5/3/25.
//

import SwiftUI

public struct LoginView: View {

    @StateObject private var viewModel: LoginViewModel

    public init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image("estatia")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)

            Text("Welcome Back")
                .font(.title)
                .fontWeight(.semibold)

            VStack(spacing: 16) {

                TextField("Email", text: $viewModel.form.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                if viewModel.form.isSecure {
                    SecureField("Password", text: $viewModel.form.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                } else {
                    TextField("Password", text: $viewModel.form.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }

                Button {
                    viewModel.form.isSecure.toggle()
                } label: {
                    Text(viewModel.form.isSecure ? "Show Password" : "Hide Password")
                        .font(.caption)
                        .foregroundColor(.blue)
                }

                Button {
                    Task { await viewModel.login() }
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(
                    viewModel.uiState.errorMessage ?? "Login failed",
                    isPresented: Binding(
                        get: { viewModel.uiState.isError },
                        set: { _ in viewModel.uiState = .idle }
                    )
                )
{
                    Button("OK", role: .cancel) {}
                }

                Button("Forgot Password?") {
                    viewModel.goToForgotPassword()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
