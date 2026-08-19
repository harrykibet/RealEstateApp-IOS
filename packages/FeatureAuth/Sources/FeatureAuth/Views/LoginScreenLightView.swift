// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/LoginScreen.kt composable LoginScreenLight
import SwiftUI

public struct LoginScreenLightView: View {
    @StateObject public var viewModel = LoginScreenLightViewModel()

    public init(viewModel: LoginScreenLightViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("LoginScreenLightView")
            .padding()
    }
}

public final class LoginScreenLightViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct LoginScreenLightView_Preview: PreviewProvider {
    static var previews: some View { LoginScreenLightView() }
}
#endif
