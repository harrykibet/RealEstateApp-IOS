// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/ExtraDetailsForm.kt composable ExtraDetailsFormLightPreview
import SwiftUI

public struct ExtraDetailsFormLightPreviewView: View {
    @StateObject public var viewModel = ExtraDetailsFormLightPreviewViewModel()

    public init(viewModel: ExtraDetailsFormLightPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("ExtraDetailsFormLightPreviewView")
            .padding()
    }
}

public final class ExtraDetailsFormLightPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct ExtraDetailsFormLightPreviewView_Preview: PreviewProvider {
    static var previews: some View { ExtraDetailsFormLightPreviewView() }
}
#endif
