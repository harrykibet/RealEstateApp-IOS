// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/PropertyFormScreen.kt composable PropertyFormPreviewDark
import SwiftUI

public struct PropertyFormPreviewDarkView: View {
    @StateObject public var viewModel = PropertyFormPreviewDarkViewModel()

    public init(viewModel: PropertyFormPreviewDarkViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("PropertyFormPreviewDarkView")
            .padding()
    }
}

public final class PropertyFormPreviewDarkViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct PropertyFormPreviewDarkView_Preview: PreviewProvider {
    static var previews: some View { PropertyFormPreviewDarkView() }
}
#endif
