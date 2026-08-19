// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/search/src/main/java/com/estatia/realestate/apps/feature/search/ui/screens/SearchScreen.kt composable EmptySearchResults
import SwiftUI

public struct EmptySearchResultsView: View {
    @StateObject public var viewModel = EmptySearchResultsViewModel()

    public init(viewModel: EmptySearchResultsViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("EmptySearchResultsView")
            .padding()
    }
}

public final class EmptySearchResultsViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct EmptySearchResultsView_Preview: PreviewProvider {
    static var previews: some View { EmptySearchResultsView() }
}
#endif
