import Foundation

public struct SettingsUiState: Equatable {
    public var isLoading: Bool
    public var errorMessage: String?

    public init(isLoading: Bool = false, errorMessage: String? = nil) {
        self.isLoading = isLoading
        self.errorMessage = errorMessage
    }
}
