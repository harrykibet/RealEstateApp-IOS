// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/search/src/main/java/com/estatia/realestate/apps/feature/search/ui/screens/SearchScreen.kt composable SearchScreenHistoryPreview
import SwiftUI

public struct SearchScreenHistoryPreviewView: View {
    @StateObject public var viewModel = SearchScreenHistoryPreviewViewModel()

    public init(viewModel: SearchScreenHistoryPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("SearchScreenHistoryPreviewView")
            .padding()
    }
}

public final class SearchScreenHistoryPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct SearchScreenHistoryPreviewView_Preview: PreviewProvider {
    static var previews: some View { SearchScreenHistoryPreviewView() }
}
#endif
