// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/PropertyDetailsScreen.kt composable StatItem
import SwiftUI

public struct StatItemView: View {
    @StateObject public var viewModel = StatItemViewModel()

    public init(viewModel: StatItemViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("StatItemView")
            .padding()
    }
}

public final class StatItemViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct StatItemView_Preview: PreviewProvider {
    static var previews: some View { StatItemView() }
}
#endif
