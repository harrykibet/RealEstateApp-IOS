// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/profile/src/main/java/com/estatia/realestate/apps/feature/profile/ui/screens/ProfileScreen.kt composable ProfileRoute
import SwiftUI

public struct ProfileRouteView: View {
    @StateObject public var viewModel = ProfileRouteViewModel()

    public init(viewModel: ProfileRouteViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                EstatiaImage(name: "app_icon")
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                EstatiaText("Real Estate App")
                EstatiaPrimaryButton(title: viewModel.loginTitle, isEnabled: !viewModel.isLoading, isLoading: viewModel.isLoading) {
                    viewModel.login()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class ProfileRouteViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct ProfileRouteView_Preview: PreviewProvider {
    static var previews: some View { ProfileRouteView() }
}
#endif
