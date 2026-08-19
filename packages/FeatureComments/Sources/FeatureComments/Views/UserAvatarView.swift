// Auto-generated stub from /Users/builder/RealEstateApp-Android/feature/comments/src/main/java/com/estatia/realestate/apps/feature/comments/ui/screens/CommentSheetContent.kt composable UserAvatar
import SwiftUI

public struct UserAvatarView: View {
    @StateObject public var viewModel = UserAvatarViewModel()

    public init(viewModel: UserAvatarViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        // TODO: Port composable UI from Android. Replace this placeholder.
        Text("UserAvatarView")
            .padding()
    }
}

public final class UserAvatarViewModel: ObservableObject {
    // TODO: Implement state and actions ported from Android ViewModel/Presenter
    @Published public var isLoading: Bool = false

    public init() {}
}

#if DEBUG
struct UserAvatarView_Preview: PreviewProvider {
    static var previews: some View { UserAvatarView() }
}
#endif
