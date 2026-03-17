//
//  PhoneVerificationView.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import SwiftUI

public struct PhoneVerificationView: View {

    @StateObject private var viewModel: PhoneVerificationViewModel

    public init(viewModel: PhoneVerificationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 16) {

            Text("Verify Phone")
                .font(.title.bold())

            TextField("Verification Code", text: $viewModel.code)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            if let error = viewModel.uiState.errorMessage {
                Text(error).foregroundColor(.red)
            }

            Button {
                Task { await viewModel.verifyCode() }
            } label: {
                Group {
                    if viewModel.uiState.isLoading {
                            ProgressView()
                        } else {
                            Text("Verify")
                        }
                    }            }
            .buttonStyle(.borderedProminent)

            Button("Verify Email Instead") {
                viewModel.verifyEmailInstead()
            }
            .font(.caption)
        }
        .padding()
    }
}
