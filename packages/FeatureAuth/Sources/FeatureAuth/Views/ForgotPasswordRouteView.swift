// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/routes/ForgotPasswordRoute.kt composable ForgotPasswordRoute
import SwiftUI

public struct ForgotPasswordRouteView: View {
    @StateObject public var viewModel = ForgotPasswordRouteViewModel()

    public init(viewModel: ForgotPasswordRouteViewModel = .init()) {
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

public final class ForgotPasswordRouteViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct ForgotPasswordRouteView_Preview: PreviewProvider {
    static var previews: some View { ForgotPasswordRouteView() }
}
#endif
