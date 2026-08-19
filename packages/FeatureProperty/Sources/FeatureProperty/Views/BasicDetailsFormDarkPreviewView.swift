// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/BasicDetailsForm.kt composable BasicDetailsFormDarkPreview
import SwiftUI

public struct BasicDetailsFormDarkPreviewView: View {
    @StateObject public var viewModel = BasicDetailsFormDarkPreviewViewModel()

    public init(viewModel: BasicDetailsFormDarkPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("BasicDetailsFormDarkPreviewView")
            .padding()
    }
}

public final class BasicDetailsFormDarkPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct BasicDetailsFormDarkPreviewView_Preview: PreviewProvider {
    static var previews: some View { BasicDetailsFormDarkPreviewView() }
}
#endif
