// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/profile/src/main/java/com/estatia/realestate/apps/feature/profile/ui/screens/ProfileScreen.kt composable ProfileScreenLightPreview
import SwiftUI

public struct ProfileScreenLightPreviewView: View {
    @StateObject public var viewModel = ProfileScreenLightPreviewViewModel()

    public init(viewModel: ProfileScreenLightPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("ProfileScreenLightPreviewView")
            .padding()
    }
}

public final class ProfileScreenLightPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct ProfileScreenLightPreviewView_Preview: PreviewProvider {
    static var previews: some View { ProfileScreenLightPreviewView() }
}
#endif
