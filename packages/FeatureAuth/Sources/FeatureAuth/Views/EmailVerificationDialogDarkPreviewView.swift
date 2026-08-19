// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/EmailVerificationDialog.kt composable EmailVerificationDialogDarkPreview
import SwiftUI

public struct EmailVerificationDialogDarkPreviewView: View {
    @StateObject public var viewModel = EmailVerificationDialogDarkPreviewViewModel()

    public init(viewModel: EmailVerificationDialogDarkPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                EstatiaText("Verify your email")
                EstatiaPrimaryButton(title: viewModel.loginTitle, isEnabled: !viewModel.isLoading, isLoading: viewModel.isLoading) {
                    viewModel.login()
                }
                EstatiaCircularProgress(state: viewModel.isLoading ? .indeterminate : .idle)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class EmailVerificationDialogDarkPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct EmailVerificationDialogDarkPreviewView_Preview: PreviewProvider {
    static var previews: some View { EmailVerificationDialogDarkPreviewView() }
}
#endif
