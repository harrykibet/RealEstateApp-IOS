// Ported from Android composable: LoginScreen
import SwiftUI
import CoreDesignSystem

public struct LoginScreenView: View {
    @StateObject public var viewModel: LoginScreenViewModel

    public init(viewModel: LoginScreenViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                Spacer().frame(height: 16)

                EstatiaText(viewModel.title)
                    .font(.title)

                EstatiaImage(name: "app_icon")
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.gray, lineWidth: 2))

                EstatiaText(viewModel.subtitle)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)

                Spacer().frame(height: 24)

                EstatiaTextField(text: $viewModel.email, placeholder: viewModel.emailPlaceholder)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)

                EstatiaTextField(text: $viewModel.password, placeholder: viewModel.passwordPlaceholder)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)

                EstatiaPrimaryButton(
                    title: viewModel.loginTitle,
                    isEnabled: !viewModel.isLoading,
                    isLoading: viewModel.isLoading
                ) {
                    viewModel.login()
                }
                .frame(maxWidth: 300)
                .padding(.top, 8)

                EstatiaCircularProgress(state: viewModel.isLoading ? .indeterminate : .idle)
                    .opacity(viewModel.isLoading ? 1 : 0)

                GoogleSignInButton(isLoading: viewModel.isLoading, isEnabled: !viewModel.isLoading) {
                    viewModel.googleSignIn()
                }
                .padding(.top, 8)

                EstatiaSecondaryButton(title: viewModel.signUpTitle) {
                    viewModel.signUp()
                }
                .frame(maxWidth: 300)
                .padding(.top, 8)

                Button(action: {
                    viewModel.forgotPassword()
                }) {
                    EstatiaText(viewModel.forgotPasswordTitle)
                        .foregroundColor(.accentColor)
                }
                .padding(.top, 8)

                Spacer().frame(height: 32)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

public final class LoginScreenViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var isLoading: Bool = false

    // Titles / strings (could be localized later)
    public var title: String = "Real Estate App"
    public var subtitle: String = "A complete solution to property owners and tenants"
    public var emailPlaceholder: String = "Email or phone number"
    public var passwordPlaceholder: String = "Password"
    public var loginTitle: String = "Login"
    public var signUpTitle: String = "Sign up"
    public var forgotPasswordTitle: String = "Forgot password"

    // Callbacks
    public var onLogin: (() -> Void)?
    public var onSignUp: (() -> Void)?
    public var onForgotPassword: (() -> Void)?
    public var onGoogleSignIn: (() -> Void)?

    public init(
        onLogin: (() -> Void)? = nil,
        onSignUp: (() -> Void)? = nil,
        onForgotPassword: (() -> Void)? = nil,
        onGoogleSignIn: (() -> Void)? = nil
    ) {
        self.onLogin = onLogin
        self.onSignUp = onSignUp
        self.onForgotPassword = onForgotPassword
        self.onGoogleSignIn = onGoogleSignIn
    }

    public func login() {
        guard !isLoading else { return }
        isLoading = true
        // In real implementation call auth service; here call the callback and stop loading.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
            self.onLogin?()
        }
    }

    public func signUp() {
        onSignUp?()
    }

    public func forgotPassword() {
        onForgotPassword?()
    }

    public func googleSignIn() {
        guard !isLoading else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
            self.onGoogleSignIn?()
        }
    }
}

#if DEBUG
struct LoginScreenView_Preview: PreviewProvider {
    static var previews: some View {
        LoginScreenView()
    }
}
#endif
