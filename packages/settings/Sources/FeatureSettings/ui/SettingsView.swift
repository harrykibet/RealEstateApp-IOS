import SwiftUI

public struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel

    public init(viewModel: SettingsViewModel = SettingsViewModel()) {
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
    SettingsView()
}
