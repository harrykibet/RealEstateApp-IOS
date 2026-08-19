// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/routes/SignUpRoute.kt composable SignUpRoute
import SwiftUI

public struct SignUpRouteView: View {
    @StateObject public var viewModel = SignUpRouteViewModel()

    public init(viewModel: SignUpRouteViewModel = .init()) {
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

public final class SignUpRouteViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct SignUpRouteView_Preview: PreviewProvider {
    static var previews: some View { SignUpRouteView() }
}
#endif
