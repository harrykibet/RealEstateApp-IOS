// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/ForgotPasswordDialog.kt composable ForgotPasswordDialogDarkPreview
import SwiftUI

public struct ForgotPasswordDialogDarkPreviewView: View {
    @StateObject public var viewModel = ForgotPasswordDialogDarkPreviewViewModel()

    public init(viewModel: ForgotPasswordDialogDarkPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                EstatiaText("Reset password")
                EstatiaTextField(text: $viewModel.email, placeholder: viewModel.emailPlaceholder)
                EstatiaTextField(text: $viewModel.password, placeholder: viewModel.passwordPlaceholder)
                EstatiaPrimaryButton(title: viewModel.loginTitle, isEnabled: !viewModel.isLoading, isLoading: viewModel.isLoading) {
                    viewModel.login()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class ForgotPasswordDialogDarkPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct ForgotPasswordDialogDarkPreviewView_Preview: PreviewProvider {
    static var previews: some View { ForgotPasswordDialogDarkPreviewView() }
}
#endif
