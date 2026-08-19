// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/PhoneVerificationDialog.kt composable PhoneVerificationDialog
import SwiftUI

public struct PhoneVerificationDialogView: View {
    @StateObject public var viewModel = PhoneVerificationDialogViewModel()

    public init(viewModel: PhoneVerificationDialogViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                EstatiaText("Real Estate App")
                EstatiaPrimaryButton(title: viewModel.loginTitle, isEnabled: !viewModel.isLoading, isLoading: viewModel.isLoading) {
                    viewModel.login()
                }
                EstatiaCircularProgress(state: viewModel.isLoading ? .indeterminate : .idle)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class PhoneVerificationDialogViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct PhoneVerificationDialogView_Preview: PreviewProvider {
    static var previews: some View { PhoneVerificationDialogView() }
}
#endif
