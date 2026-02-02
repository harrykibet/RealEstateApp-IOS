import Foundation

public struct TestClock {
    public var now: () -> Date

    public init(now: @escaping () -> Date = Date.init) {
        self.now = now
    }
}
