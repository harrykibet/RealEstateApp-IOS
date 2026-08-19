// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/LocationInfoForm.kt composable LocationInfoFormLightPreview
import SwiftUI

public struct LocationInfoFormLightPreviewView: View {
    @StateObject public var viewModel = LocationInfoFormLightPreviewViewModel()

    public init(viewModel: LocationInfoFormLightPreviewViewModel = .init()) {
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

public final class LocationInfoFormLightPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct LocationInfoFormLightPreviewView_Preview: PreviewProvider {
    static var previews: some View { LocationInfoFormLightPreviewView() }
}
#endif
