// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/PropertyDetailsScreen.kt composable PropertyDetailsScreen
import SwiftUI

public struct PropertyDetailsScreenView: View {
    @StateObject public var viewModel = PropertyDetailsScreenViewModel()

    public init(viewModel: PropertyDetailsScreenViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("PropertyDetailsScreenView")
            .padding()
    }
}

public final class PropertyDetailsScreenViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct PropertyDetailsScreenView_Preview: PreviewProvider {
    static var previews: some View { PropertyDetailsScreenView() }
}
#endif
