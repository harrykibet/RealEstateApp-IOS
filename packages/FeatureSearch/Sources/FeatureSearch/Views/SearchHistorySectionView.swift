// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/search/src/main/java/com/estatia/realestate/apps/feature/search/ui/screens/SearchScreen.kt composable SearchHistorySection
import SwiftUI

public struct SearchHistorySectionView: View {
    @StateObject public var viewModel = SearchHistorySectionViewModel()

    public init(viewModel: SearchHistorySectionViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                EstatiaText("Recent Searches")
                EstatiaCircularProgress(state: viewModel.isLoading ? .indeterminate : .idle)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class SearchHistorySectionViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct SearchHistorySectionView_Preview: PreviewProvider {
    static var previews: some View { SearchHistorySectionView() }
}
#endif
