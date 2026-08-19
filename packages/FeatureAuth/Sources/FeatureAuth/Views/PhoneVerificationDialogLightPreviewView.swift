// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/PhoneVerificationDialog.kt composable PhoneVerificationDialogLightPreview
import SwiftUI

public struct PhoneVerificationDialogLightPreviewView: View {
    @StateObject public var viewModel = PhoneVerificationDialogLightPreviewViewModel()

    public init(viewModel: PhoneVerificationDialogLightPreviewViewModel = .init()) {
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

public final class PhoneVerificationDialogLightPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct PhoneVerificationDialogLightPreviewView_Preview: PreviewProvider {
    static var previews: some View { PhoneVerificationDialogLightPreviewView() }
}
#endif
