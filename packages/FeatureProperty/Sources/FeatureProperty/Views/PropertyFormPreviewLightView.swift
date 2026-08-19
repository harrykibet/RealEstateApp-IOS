// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/PropertyFormScreen.kt composable PropertyFormPreviewLight
import SwiftUI

public struct PropertyFormPreviewLightView: View {
    @StateObject public var viewModel = PropertyFormPreviewLightViewModel()

    public init(viewModel: PropertyFormPreviewLightViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("PropertyFormPreviewLightView")
            .padding()
    }
}

public final class PropertyFormPreviewLightViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct PropertyFormPreviewLightView_Preview: PreviewProvider {
    static var previews: some View { PropertyFormPreviewLightView() }
}
#endif
