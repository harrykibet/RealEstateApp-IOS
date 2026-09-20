import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Observes application lifecycle and exposes simple callbacks for background/foreground transitions.
public final class EnvironmentManager {
    private var backgroundObserver: NSObjectProtocol?
    private var foregroundObserver: NSObjectProtocol?

    public init() {}

    public func start(onAppBackgrounded: @escaping () -> Void, onAppForegrounded: @escaping () -> Void) {
        #if canImport(UIKit)
        let nc = NotificationCenter.default
        backgroundObserver = nc.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
            onAppBackgrounded()
        }
        foregroundObserver = nc.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            onAppForegrounded()
        }
        #else
        // No-op on platforms without UIKit; callers should not rely on lifecycle callbacks in that environment.
        #endif
    }

    public func stop() {
        #if canImport(UIKit)
        let nc = NotificationCenter.default
        if let obs = backgroundObserver { nc.removeObserver(obs) }
        if let obs = foregroundObserver { nc.removeObserver(obs) }
        backgroundObserver = nil
        foregroundObserver = nil
        #else
        // no-op
        #endif
    }
}
