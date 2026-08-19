// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/profile/src/main/java/com/estatia/realestate/apps/feature/profile/ui/screens/ProfileScreen.kt composable ProfileScreenDarkPreview
import SwiftUI

public struct ProfileScreenDarkPreviewView: View {
    @StateObject public var viewModel = ProfileScreenDarkPreviewViewModel()

    public init(viewModel: ProfileScreenDarkPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("ProfileScreenDarkPreviewView")
            .padding()
    }
}

public final class ProfileScreenDarkPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct ProfileScreenDarkPreviewView_Preview: PreviewProvider {
    static var previews: some View { ProfileScreenDarkPreviewView() }
}
#endif
