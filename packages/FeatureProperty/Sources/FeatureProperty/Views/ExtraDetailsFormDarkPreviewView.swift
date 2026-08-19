// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/ExtraDetailsForm.kt composable ExtraDetailsFormDarkPreview
import SwiftUI

public struct ExtraDetailsFormDarkPreviewView: View {
    @StateObject public var viewModel = ExtraDetailsFormDarkPreviewViewModel()

    public init(viewModel: ExtraDetailsFormDarkPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("ExtraDetailsFormDarkPreviewView")
            .padding()
    }
}

public final class ExtraDetailsFormDarkPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct ExtraDetailsFormDarkPreviewView_Preview: PreviewProvider {
    static var previews: some View { ExtraDetailsFormDarkPreviewView() }
}
#endif
