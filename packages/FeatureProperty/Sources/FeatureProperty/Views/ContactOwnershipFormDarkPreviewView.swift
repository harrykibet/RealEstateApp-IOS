// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/property/src/main/java/com/estatia/realestate/apps/feature/property/ui/screens/ContactOwnershipForm.kt composable ContactOwnershipFormDarkPreview
import SwiftUI

public struct ContactOwnershipFormDarkPreviewView: View {
    @StateObject public var viewModel = ContactOwnershipFormDarkPreviewViewModel()

    public init(viewModel: ContactOwnershipFormDarkPreviewViewModel = .init()) {
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

public final class ContactOwnershipFormDarkPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct ContactOwnershipFormDarkPreviewView_Preview: PreviewProvider {
    static var previews: some View { ContactOwnershipFormDarkPreviewView() }
}
#endif
