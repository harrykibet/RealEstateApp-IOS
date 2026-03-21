
import SwiftUI

public enum AuthFlow {
    case login
    case signup
    case forgotPassword
    case phoneVerification
    case emailVerification
}

public struct AuthEntryView: View {
    @StateObject private var coordinator: AuthCoordinatorViewModel

    public init(coordinator: AuthCoordinatorViewModel = AuthCoordinatorViewModel()) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    public var body: some View {
        NavigationStack {
            content
        }
    }

    @ViewBuilder
    private var content: some View {
        switch coordinator.flow {
        case .login:
            LoginView(
                viewModel: LoginViewModel(coordinator: coordinator)
            )

        case .signup:
            SignupView(
                viewModel: SignupViewModel(coordinator: coordinator)
            )

        case .forgotPassword:
            ForgotPasswordView(
                viewModel: ForgotPasswordViewModel(coordinator: coordinator)
            )

        case .phoneVerification:
            PhoneVerificationView(
                viewModel: PhoneVerificationViewModel(coordinator: coordinator)
            )

        case .emailVerification:
            EmailVerificationView(
                viewModel: EmailVerificationViewModel(coordinator: coordinator)
            )
        }
    }
}
