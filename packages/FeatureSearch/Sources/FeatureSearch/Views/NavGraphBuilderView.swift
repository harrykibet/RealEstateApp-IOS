// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/search/src/main/java/com/estatia/realestate/apps/feature/search/navigation/SearchNavigation.kt composable NavGraphBuilder
import SwiftUI

public struct NavGraphBuilderView: View {
    @StateObject public var viewModel = NavGraphBuilderViewModel()

    public init(viewModel: NavGraphBuilderViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("NavGraphBuilderView")
            .padding()
    }
}

public final class NavGraphBuilderViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct NavGraphBuilderView_Preview: PreviewProvider {
    static var previews: some View { NavGraphBuilderView() }
}
#endif
