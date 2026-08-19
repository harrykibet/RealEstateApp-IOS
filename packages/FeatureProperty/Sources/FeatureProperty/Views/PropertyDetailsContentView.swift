// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/PropertyDetailsScreen.kt composable PropertyDetailsContent
import SwiftUI

public struct PropertyDetailsContentView: View {
    @StateObject public var viewModel = PropertyDetailsContentViewModel()

    public init(viewModel: PropertyDetailsContentViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("PropertyDetailsContentView")
            .padding()
    }
}

public final class PropertyDetailsContentViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct PropertyDetailsContentView_Preview: PreviewProvider {
    static var previews: some View { PropertyDetailsContentView() }
}
#endif
