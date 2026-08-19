// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/SignUpScreen.kt composable SignUpScreenDarkPreview
import SwiftUI

public struct SignUpScreenDarkPreviewView: View {
    @StateObject public var viewModel = SignUpScreenDarkPreviewViewModel()

    public init(viewModel: SignUpScreenDarkPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("SignUpScreenDarkPreviewView")
            .padding()
    }
}

public final class SignUpScreenDarkPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct SignUpScreenDarkPreviewView_Preview: PreviewProvider {
    static var previews: some View { SignUpScreenDarkPreviewView() }
}
#endif
