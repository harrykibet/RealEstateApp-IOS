import SwiftUI

private struct AppDIKey: EnvironmentKey {
    static let defaultValue: AppDIContainer? = nil
}

extension EnvironmentValues {
    var di: AppDIContainer? {
        get { self[AppDIKey.self] }
        set { self[AppDIKey.self] = newValue }
    }
}
