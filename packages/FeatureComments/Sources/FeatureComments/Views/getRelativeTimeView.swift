// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/comments/src/main/java/com/estatia/realestate/apps/feature/comments/ui/screens/CommentSheetContent.kt composable getRelativeTime
import SwiftUI

public struct getRelativeTimeView: View {
    @StateObject public var viewModel = getRelativeTimeViewModel()

    public init(viewModel: getRelativeTimeViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                EstatiaText("Reply")
                EstatiaCircularProgress(state: viewModel.isLoading ? .indeterminate : .idle)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class getRelativeTimeViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct getRelativeTimeView_Preview: PreviewProvider {
    static var previews: some View { getRelativeTimeView() }
}
#endif
