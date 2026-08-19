// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/PropertyDetailsScreen.kt composable PropertyDetailsScreenLoadingPreview
import SwiftUI

public struct PropertyDetailsScreenLoadingPreviewView: View {
    @StateObject public var viewModel = PropertyDetailsScreenLoadingPreviewViewModel()

    public init(viewModel: PropertyDetailsScreenLoadingPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("PropertyDetailsScreenLoadingPreviewView")
            .padding()
    }
}

public final class PropertyDetailsScreenLoadingPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct PropertyDetailsScreenLoadingPreviewView_Preview: PreviewProvider {
    static var previews: some View { PropertyDetailsScreenLoadingPreviewView() }
}
#endif
