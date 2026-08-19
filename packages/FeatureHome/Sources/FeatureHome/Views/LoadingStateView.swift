// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/home/src/main/java/com/estatia/realestate/apps/feature/home/ui/screens/HomeScreen.kt composable LoadingState
import SwiftUI

public struct LoadingStateView: View {
    @StateObject public var viewModel = LoadingStateViewModel()

    public init(viewModel: LoadingStateViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("LoadingStateView")
            .padding()
    }
}

public final class LoadingStateViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct LoadingStateView_Preview: PreviewProvider {
    static var previews: some View { LoadingStateView() }
}
#endif
