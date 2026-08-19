// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/ContactOwnershipForm.kt composable ContactOwnershipForm
import SwiftUI

public struct ContactOwnershipFormView: View {
    @StateObject public var viewModel = ContactOwnershipFormViewModel()

    public init(viewModel: ContactOwnershipFormViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("ContactOwnershipFormView")
            .padding()
    }
}

public final class ContactOwnershipFormViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct ContactOwnershipFormView_Preview: PreviewProvider {
    static var previews: some View { ContactOwnershipFormView() }
}
#endif
