import SwiftUI

public struct AuthView: View {
    @StateObject private var viewModel: AuthViewModel

    public init(viewModel: AuthViewModel = AuthViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text(viewModel.title)
                    .font(.title2.bold())

                Text(viewModel.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                statusView
            }
            .padding()
            .navigationTitle(viewModel.title)
        }
        .onAppear { viewModel.onAppear() }
    }

    @ViewBuilder
    private var statusView: some View {
        switch viewModel.state {
        case .idle:
            Text("Ready")
                .font(.caption)
                .foregroundColor(.secondary)
        case .loading:
            ProgressView()
        case .error(let message):
            Text(message)
                .font(.caption)
                .foregroundColor(.red)
        }
    }
}

#Preview {
    AuthView()
}
