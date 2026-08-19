// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/home/src/main/java/com/estatia/realestate/apps/feature/home/navigation/HomeNavigation.kt composable NavGraphBuilder
import SwiftUI

public struct NavGraphBuilderView: View {
    @StateObject public var viewModel = NavGraphBuilderViewModel()

    public init(viewModel: NavGraphBuilderViewModel = .init()) {
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
