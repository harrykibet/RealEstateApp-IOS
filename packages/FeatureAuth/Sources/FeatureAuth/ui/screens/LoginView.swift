//
//  ContentView.swift
//  auth
//
//  Created by builder on 5/3/25.
//

import SwiftUI
import CoreModel

public struct LoginView: View {

    // MARK: - State

    @ObservedObject
    private var viewModel: LoginViewModel

    // MARK: - Actions

    private let onAuthSessionReceived: (AuthSession) -> Void

    private let onSignupTapped: () -> Void

    private let onForgotPasswordTapped: () -> Void

    // MARK: - Init

    public init(
        viewModel: LoginViewModel,
        onAuthSessionReceived: @escaping (AuthSession) -> Void,
        onSignupTapped: @escaping () -> Void,
        onForgotPasswordTapped: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onAuthSessionReceived = onAuthSessionReceived
        self.onSignupTapped = onSignupTapped
        self.onForgotPasswordTapped = onForgotPasswordTapped
    }

    // MARK: - Body

    public var body: some View {

        VStack {

            Button("Login") {

                Task {

                    guard let session =
                        await viewModel.login()
                    else {
                        return
                    }

                    onAuthSessionReceived(session)
                }
            }

            Button("Signup") {
                onSignupTapped()
            }

            Button("Forgot Password") {
                onForgotPasswordTapped()
            }
        }
    }
}
