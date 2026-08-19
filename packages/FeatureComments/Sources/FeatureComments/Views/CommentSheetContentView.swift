// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/comments/src/main/java/com/estatia/realestate/apps/feature/comments/ui/screens/CommentSheetContent.kt composable CommentSheetContent
import SwiftUI

public struct CommentSheetContentView: View {
    @StateObject public var viewModel = CommentSheetContentViewModel()

    public init(viewModel: CommentSheetContentViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("CommentSheetContentView")
            .padding()
    }
}

public final class CommentSheetContentViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct CommentSheetContentView_Preview: PreviewProvider {
    static var previews: some View { CommentSheetContentView() }
}
#endif
