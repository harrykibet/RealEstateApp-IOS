// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/LoginScreen.kt composable LoginScreenDark
import SwiftUI

public struct LoginScreenDarkView: View {
    @StateObject public var viewModel = LoginScreenDarkViewModel()

    public init(viewModel: LoginScreenDarkViewModel = .init()) {
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

public final class LoginScreenDarkViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct LoginScreenDarkView_Preview: PreviewProvider {
    static var previews: some View { LoginScreenDarkView() }
}
#endif
