// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/LocationInfoForm.kt composable LocationInfoFormDarkPreview
import SwiftUI

public struct LocationInfoFormDarkPreviewView: View {
    @StateObject public var viewModel = LocationInfoFormDarkPreviewViewModel()

    public init(viewModel: LocationInfoFormDarkPreviewViewModel = .init()) {
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

public final class LocationInfoFormDarkPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct LocationInfoFormDarkPreviewView_Preview: PreviewProvider {
    static var previews: some View { LocationInfoFormDarkPreviewView() }
}
#endif
