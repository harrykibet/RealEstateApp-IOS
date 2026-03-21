import Foundation

public protocol SecureStore {
    func save(_ value: String, forKey key: String) throws
    func read(forKey key: String) throws -> String?
    func delete(forKey key: String) throws
}

public final class InMemorySecureStore: SecureStore {
    private var store: [String: String] = [:]

    public init() {}

    public func save(_ value: String, forKey key: String) throws {
        store[key] = value
    }

    public func read(forKey key: String) throws -> String? {
        store[key]
    }

    public func delete(forKey key: String) throws {
        store[key] = nil
    }
}
