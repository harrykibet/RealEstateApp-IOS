// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/SignUpScreen.kt composable SignUpScreenLightPreview
import SwiftUI

public struct SignUpScreenLightPreviewView: View {
    @StateObject public var viewModel = SignUpScreenLightPreviewViewModel()

    public init(viewModel: SignUpScreenLightPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("SignUpScreenLightPreviewView")
            .padding()
    }
}

public final class SignUpScreenLightPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct SignUpScreenLightPreviewView_Preview: PreviewProvider {
    static var previews: some View { SignUpScreenLightPreviewView() }
}
#endif
