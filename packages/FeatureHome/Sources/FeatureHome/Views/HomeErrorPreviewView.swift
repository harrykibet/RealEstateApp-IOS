// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/home/src/main/java/com/estatia/realestate/apps/feature/home/ui/screens/HomeScreen.kt composable HomeErrorPreview
import SwiftUI

public struct HomeErrorPreviewView: View {
    @StateObject public var viewModel = HomeErrorPreviewViewModel()

    public init(viewModel: HomeErrorPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("HomeErrorPreviewView")
            .padding()
    }
}

public final class HomeErrorPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct HomeErrorPreviewView_Preview: PreviewProvider {
    static var previews: some View { HomeErrorPreviewView() }
}
#endif
