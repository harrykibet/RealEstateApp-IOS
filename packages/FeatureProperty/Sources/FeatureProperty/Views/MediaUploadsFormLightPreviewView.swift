// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/MediaUploadsForm.kt composable MediaUploadsFormLightPreview
import SwiftUI

public struct MediaUploadsFormLightPreviewView: View {
    @StateObject public var viewModel = MediaUploadsFormLightPreviewViewModel()

    public init(viewModel: MediaUploadsFormLightPreviewViewModel = .init()) {
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

public final class MediaUploadsFormLightPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct MediaUploadsFormLightPreviewView_Preview: PreviewProvider {
    static var previews: some View { MediaUploadsFormLightPreviewView() }
}
#endif
