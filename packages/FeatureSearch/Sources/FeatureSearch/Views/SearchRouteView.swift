// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/search/src/main/java/com/estatia/realestate/apps/feature/search/ui/screens/SearchScreen.kt composable SearchRoute
import SwiftUI

public struct SearchRouteView: View {
    @StateObject public var viewModel = SearchRouteViewModel()

    public init(viewModel: SearchRouteViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("SearchRouteView")
            .padding()
    }
}

public final class SearchRouteViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct SearchRouteView_Preview: PreviewProvider {
    static var previews: some View { SearchRouteView() }
}
#endif
