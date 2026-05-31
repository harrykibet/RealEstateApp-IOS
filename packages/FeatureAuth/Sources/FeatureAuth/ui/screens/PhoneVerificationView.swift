//
//  PhoneVerificationView.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import SwiftUI
import CoreModel

public struct PhoneVerificationView: View {

    // MARK: - State

    @ObservedObject
    private var viewModel: PhoneVerificationViewModel

    // MARK: - Actions

    private let onVerificationSuccess: (AuthSession) -> Void

    private let onVerifyEmailInstead: () -> Void

    // MARK: - Init

    public init(
        viewModel: PhoneVerificationViewModel,
        onVerificationSuccess: @escaping (AuthSession) -> Void,
        onVerifyEmailInstead: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onVerificationSuccess = onVerificationSuccess
        self.onVerifyEmailInstead = onVerifyEmailInstead
    }

    // MARK: - Body

    public var body: some View {

        VStack(spacing: 16) {

            Text("Verify Phone")
                .font(.title.bold())

            TextField(
                "Verification Code",
                text: $viewModel.form.code
            )
            .keyboardType(.numberPad)
            .textFieldStyle(.roundedBorder)

            if let error = viewModel.uiState.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button {
                Task {

                    guard let session =
                        await viewModel.verifyCode()
                    else {
                        return
                    }

                    onVerificationSuccess(session)
                }
            } label: {

                if viewModel.uiState.isLoading {
                    ProgressView()
                } else {
                    Text("Verify")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.uiState.isLoading)

            Button("Verify Email Instead") {
                onVerifyEmailInstead()
            }
            .font(.caption)
        }
        .padding()
    }
}
