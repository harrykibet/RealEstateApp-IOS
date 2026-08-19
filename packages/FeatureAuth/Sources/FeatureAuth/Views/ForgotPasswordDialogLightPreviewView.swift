// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/ForgotPasswordDialog.kt composable ForgotPasswordDialogLightPreview
import SwiftUI

public struct ForgotPasswordDialogLightPreviewView: View {
    @StateObject public var viewModel = ForgotPasswordDialogLightPreviewViewModel()

    public init(viewModel: ForgotPasswordDialogLightPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("ForgotPasswordDialogLightPreviewView")
            .padding()
    }
}

public final class ForgotPasswordDialogLightPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct ForgotPasswordDialogLightPreviewView_Preview: PreviewProvider {
    static var previews: some View { ForgotPasswordDialogLightPreviewView() }
}
#endif
