// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/PropertyDetailsScreen.kt composable PropertyDetailsScreenErrorPreview
import SwiftUI

public struct PropertyDetailsScreenErrorPreviewView: View {
    @StateObject public var viewModel = PropertyDetailsScreenErrorPreviewViewModel()

    public init(viewModel: PropertyDetailsScreenErrorPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("PropertyDetailsScreenErrorPreviewView")
            .padding()
    }
}

public final class PropertyDetailsScreenErrorPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct PropertyDetailsScreenErrorPreviewView_Preview: PreviewProvider {
    static var previews: some View { PropertyDetailsScreenErrorPreviewView() }
}
#endif
