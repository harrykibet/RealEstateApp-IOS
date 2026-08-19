// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/EmailVerificationDialog.kt composable EmailVerificationDialogLightPreview
import SwiftUI

public struct EmailVerificationDialogLightPreviewView: View {
    @StateObject public var viewModel = EmailVerificationDialogLightPreviewViewModel()

    public init(viewModel: EmailVerificationDialogLightPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("EmailVerificationDialogLightPreviewView")
            .padding()
    }
}

public final class EmailVerificationDialogLightPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct EmailVerificationDialogLightPreviewView_Preview: PreviewProvider {
    static var previews: some View { EmailVerificationDialogLightPreviewView() }
}
#endif
