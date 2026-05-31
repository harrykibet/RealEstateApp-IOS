//
//  EmailVerificationView.swift
//  auth
//
//  Created by builder on 1/31/26.
//

import SwiftUI
import CoreModel

public struct EmailVerificationView: View {
    
    @ObservedObject
    private var viewModel: EmailVerificationViewModel
    
    private let onAuthSessionReceived: (AuthSession) -> Void
    
    public init(
        viewModel: EmailVerificationViewModel,
        onAuthSessionReceived: @escaping (AuthSession) -> Void
    ) {
        self.viewModel = viewModel
        self.onAuthSessionReceived = onAuthSessionReceived
    }
    
    public var body: some View {
        
        VStack(spacing: 16) {
            
            Text("Verify Email")
                .font(.title.bold())
            
            Text(
                "Check your inbox and verify your email address."
            )
            .multilineTextAlignment(.center)
            
            if let message = viewModel.uiState.errorMessage {
                Text(message)
                    .foregroundColor(.green)
            }
            
            Button {
                Task {
                    await viewModel.resendEmail()
                }
            } label: {
                
                if viewModel.uiState.isLoading {
                    ProgressView()
                } else {
                    Text("Resend Email")
                }
            }
            .buttonStyle(.bordered)
            
            Button("I've Verified My Email") {
                Task {
                    await verifyEmail()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func verifyEmail() async {
        
        do {
            
            let session = try await viewModel.refreshSession()
            
            if case .authenticated(
                _,
                .authenticated
            ) = session {
                
                onAuthSessionReceived(session)
            }
            
        } catch {
            // update UI state
        }
    }
}
