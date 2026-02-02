import Foundation

public enum LogLevel: String {
    case debug
    case info
    case warning
    case error
}

public protocol Logger {
    func log(_ message: String, level: LogLevel)
}

public struct ConsoleLogger: Logger {
    public init() {}

    public func log(_ message: String, level: LogLevel) {
        print("[\(level.rawValue.uppercased())] \(message)")
    }
}
