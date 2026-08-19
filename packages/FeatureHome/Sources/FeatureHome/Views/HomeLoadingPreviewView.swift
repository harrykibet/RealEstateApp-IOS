// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/home/src/main/java/com/estatia/realestate/apps/feature/home/ui/screens/HomeScreen.kt composable HomeLoadingPreview
import SwiftUI

public struct HomeLoadingPreviewView: View {
    @StateObject public var viewModel = HomeLoadingPreviewViewModel()

    public init(viewModel: HomeLoadingPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                EstatiaText("Real Estate App")
                EstatiaPrimaryButton(title: viewModel.loginTitle, isEnabled: !viewModel.isLoading, isLoading: viewModel.isLoading) {
                    viewModel.login()
                }
                EstatiaCircularProgress(state: viewModel.isLoading ? .indeterminate : .idle)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class HomeLoadingPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct HomeLoadingPreviewView_Preview: PreviewProvider {
    static var previews: some View { HomeLoadingPreviewView() }
}
#endif
