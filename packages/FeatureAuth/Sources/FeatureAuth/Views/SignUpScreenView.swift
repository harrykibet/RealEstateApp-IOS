// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/SignUpScreen.kt composable SignUpScreen
import SwiftUI

public struct SignUpScreenView: View {
    @StateObject public var viewModel = SignUpScreenViewModel()

    public init(viewModel: SignUpScreenViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("SignUpScreenView")
            .padding()
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
