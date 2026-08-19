// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/PhoneVerificationDialog.kt composable PhoneVerificationDialogDarkPreview
import SwiftUI

public struct PhoneVerificationDialogDarkPreviewView: View {
    @StateObject public var viewModel = PhoneVerificationDialogDarkPreviewViewModel()

    public init(viewModel: PhoneVerificationDialogDarkPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("PhoneVerificationDialogDarkPreviewView")
            .padding()
    }
}

public final class PhoneVerificationDialogDarkPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct PhoneVerificationDialogDarkPreviewView_Preview: PreviewProvider {
    static var previews: some View { PhoneVerificationDialogDarkPreviewView() }
}
#endif
