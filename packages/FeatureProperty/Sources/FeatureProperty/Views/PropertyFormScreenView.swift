// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/PropertyFormScreen.kt composable PropertyFormScreen
import SwiftUI

public struct PropertyFormScreenView: View {
    @StateObject public var viewModel = PropertyFormScreenViewModel()

    public init(viewModel: PropertyFormScreenViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class PropertyFormScreenViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct PropertyFormScreenView_Preview: PreviewProvider {
    static var previews: some View { PropertyFormScreenView() }
}
#endif
