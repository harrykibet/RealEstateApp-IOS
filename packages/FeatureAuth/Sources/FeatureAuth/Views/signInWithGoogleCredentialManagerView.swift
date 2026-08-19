// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/routes/LoginRoute.kt composable signInWithGoogleCredentialManager
import SwiftUI

public struct signInWithGoogleCredentialManagerView: View {
    @StateObject public var viewModel = signInWithGoogleCredentialManagerViewModel()

    public init(viewModel: signInWithGoogleCredentialManagerViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class signInWithGoogleCredentialManagerViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct signInWithGoogleCredentialManagerView_Preview: PreviewProvider {
    static var previews: some View { signInWithGoogleCredentialManagerView() }
}
#endif
