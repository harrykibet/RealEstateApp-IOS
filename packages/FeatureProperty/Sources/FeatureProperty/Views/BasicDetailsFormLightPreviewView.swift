// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/BasicDetailsForm.kt composable BasicDetailsFormLightPreview
import SwiftUI

public struct BasicDetailsFormLightPreviewView: View {
    @StateObject public var viewModel = BasicDetailsFormLightPreviewViewModel()

    public init(viewModel: BasicDetailsFormLightPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                EstatiaText("Enter a short, clear title for the property (e.g., '2 Bedroom Apartment in Kilimani')")
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class BasicDetailsFormLightPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct BasicDetailsFormLightPreviewView_Preview: PreviewProvider {
    static var previews: some View { BasicDetailsFormLightPreviewView() }
}
#endif
