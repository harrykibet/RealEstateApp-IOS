// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/home/src/main/java/com/estatia/realestate/apps/feature/home/ui/screens/HomeScreen.kt composable HomeContentPreview
import SwiftUI

public struct HomeContentPreviewView: View {
    @StateObject public var viewModel = HomeContentPreviewViewModel()

    public init(viewModel: HomeContentPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("HomeContentPreviewView")
            .padding()
    }
}

public final class HomeContentPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct HomeContentPreviewView_Preview: PreviewProvider {
    static var previews: some View { HomeContentPreviewView() }
}
#endif
