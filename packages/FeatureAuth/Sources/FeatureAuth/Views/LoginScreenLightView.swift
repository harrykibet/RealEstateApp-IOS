// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/LoginScreen.kt composable LoginScreenLight
import SwiftUI

public struct LoginScreenLightView: View {
    @StateObject public var viewModel = LoginScreenLightViewModel()

    public init(viewModel: LoginScreenLightViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                EstatiaImage(name: "app_icon")
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                EstatiaText("Real Estate App")
                EstatiaTextField(text: $viewModel.email, placeholder: viewModel.emailPlaceholder)
                EstatiaTextField(text: $viewModel.password, placeholder: viewModel.passwordPlaceholder)
                EstatiaPrimaryButton(title: viewModel.loginTitle, isEnabled: !viewModel.isLoading, isLoading: viewModel.isLoading) {
                    viewModel.login()
                }
                GoogleSignInButton(isLoading: viewModel.isLoading, isEnabled: !viewModel.isLoading) {
                    viewModel.googleSignIn()
                }
                EstatiaCircularProgress(state: viewModel.isLoading ? .indeterminate : .idle)
            }
            .frame(maxWidth: .infinity)
        }
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
