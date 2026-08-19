// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/SignUpScreen.kt composable SignUpScreen
import SwiftUI

public struct SignUpScreenView: View {
    @StateObject public var viewModel = SignUpScreenViewModel()

    public init(viewModel: SignUpScreenViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                EstatiaText("Real Estate App")
                EstatiaTextField(text: $viewModel.email, placeholder: viewModel.emailPlaceholder)
                EstatiaTextField(text: $viewModel.password, placeholder: viewModel.passwordPlaceholder)
                EstatiaPrimaryButton(title: viewModel.loginTitle, isEnabled: !viewModel.isLoading, isLoading: viewModel.isLoading) {
                    viewModel.login()
                }
                EstatiaCircularProgress(state: viewModel.isLoading ? .indeterminate : .idle)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class SignUpScreenViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct SignUpScreenView_Preview: PreviewProvider {
    static var previews: some View { SignUpScreenView() }
}
#endif
