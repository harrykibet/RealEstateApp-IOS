import Foundation
import UIKit

/// Observes application lifecycle and exposes simple callbacks for background/foreground transitions.
public final class EnvironmentManager {
    private var backgroundObserver: NSObjectProtocol?
    private var foregroundObserver: NSObjectProtocol?

    public init() {}

    public func start(onAppBackgrounded: @escaping () -> Void, onAppForegrounded: @escaping () -> Void) {
        let nc = NotificationCenter.default
        backgroundObserver = nc.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
            onAppBackgrounded()
        }
        foregroundObserver = nc.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            onAppForegrounded()
        }
    }

    public func stop() {
        let nc = NotificationCenter.default
        if let obs = backgroundObserver { nc.removeObserver(obs) }
        if let obs = foregroundObserver { nc.removeObserver(obs) }
        backgroundObserver = nil
        foregroundObserver = nil
    }
}
