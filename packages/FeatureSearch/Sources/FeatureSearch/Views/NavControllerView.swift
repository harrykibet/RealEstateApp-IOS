// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/search/src/main/java/com/estatia/realestate/apps/feature/search/navigation/SearchNavigation.kt composable NavController
import SwiftUI

public struct NavControllerView: View {
    @StateObject public var viewModel = NavControllerViewModel()

    public init(viewModel: NavControllerViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class NavControllerViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct NavControllerView_Preview: PreviewProvider {
    static var previews: some View { NavControllerView() }
}
#endif
