// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/home/src/main/java/com/estatia/realestate/apps/feature/home/ui/screens/HomeScreen.kt composable EmptyState
import SwiftUI

public struct EmptyStateView: View {
    @StateObject public var viewModel = EmptyStateViewModel()

    public init(viewModel: EmptyStateViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("EmptyStateView")
            .padding()
    }
}

public final class EmptyStateViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct EmptyStateView_Preview: PreviewProvider {
    static var previews: some View { EmptyStateView() }
}
#endif
