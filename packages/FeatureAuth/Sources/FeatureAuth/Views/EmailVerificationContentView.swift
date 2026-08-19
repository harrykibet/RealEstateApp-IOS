// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/auth/src/main/java/com/estatia/realestate/apps/feature/auth/ui/screens/EmailVerificationDialog.kt composable EmailVerificationContent
import SwiftUI

public struct EmailVerificationContentView: View {
    @StateObject public var viewModel = EmailVerificationContentViewModel()

    public init(viewModel: EmailVerificationContentViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("EmailVerificationContentView")
            .padding()
    }
}

public final class EmailVerificationContentViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct EmailVerificationContentView_Preview: PreviewProvider {
    static var previews: some View { EmailVerificationContentView() }
}
#endif
