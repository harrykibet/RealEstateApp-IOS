// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/search/src/main/java/com/estatia/realestate/apps/feature/search/ui/screens/SearchScreen.kt composable SearchScreen
import SwiftUI

public struct SearchScreenView: View {
    @StateObject public var viewModel = SearchScreenViewModel()

    public init(viewModel: SearchScreenViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("SearchScreenView")
            .padding()
    }
}

public final class SearchScreenViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct SearchScreenView_Preview: PreviewProvider {
    static var previews: some View { SearchScreenView() }
}
#endif
