// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/home/src/main/java/com/estatia/realestate/apps/feature/home/ui/screens/HomeScreen.kt composable ErrorState
import SwiftUI

public struct ErrorStateView: View {
    @StateObject public var viewModel = ErrorStateViewModel()

    public init(viewModel: ErrorStateViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("ErrorStateView")
            .padding()
    }
}

public final class ErrorStateViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct ErrorStateView_Preview: PreviewProvider {
    static var previews: some View { ErrorStateView() }
}
#endif
