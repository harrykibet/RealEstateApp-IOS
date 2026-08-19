// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/LocationInfoForm.kt composable LocationInfoForm
import SwiftUI

public struct LocationInfoFormView: View {
    @StateObject public var viewModel = LocationInfoFormViewModel()

    public init(viewModel: LocationInfoFormViewModel = .init()) {
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

public final class LocationInfoFormViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct LocationInfoFormView_Preview: PreviewProvider {
    static var previews: some View { LocationInfoFormView() }
}
#endif
