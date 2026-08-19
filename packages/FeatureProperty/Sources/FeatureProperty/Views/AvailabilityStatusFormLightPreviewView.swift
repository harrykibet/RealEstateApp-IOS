// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/AvailabilityStatusForm.kt composable AvailabilityStatusFormLightPreview
import SwiftUI

public struct AvailabilityStatusFormLightPreviewView: View {
    @StateObject public var viewModel = AvailabilityStatusFormLightPreviewViewModel()

    public init(viewModel: AvailabilityStatusFormLightPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("AvailabilityStatusFormLightPreviewView")
            .padding()
    }
}

public final class AvailabilityStatusFormLightPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct AvailabilityStatusFormLightPreviewView_Preview: PreviewProvider {
    static var previews: some View { AvailabilityStatusFormLightPreviewView() }
}
#endif
