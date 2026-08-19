// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/comments/src/main/java/com/estatia/realestate/apps/feature/comments/ui/screens/CommentSheetContent.kt composable CommentSheetContentSendingPreview
import SwiftUI

public struct CommentSheetContentSendingPreviewView: View {
    @StateObject public var viewModel = CommentSheetContentSendingPreviewViewModel()

    public init(viewModel: CommentSheetContentSendingPreviewViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("CommentSheetContentSendingPreviewView")
            .padding()
    }
}

public final class CommentSheetContentSendingPreviewViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct CommentSheetContentSendingPreviewView_Preview: PreviewProvider {
    static var previews: some View { CommentSheetContentSendingPreviewView() }
}
#endif
