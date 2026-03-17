import Foundation

public protocol DatabaseClient {
    func save(_ data: Data, forKey key: String) throws
    func load(forKey key: String) throws -> Data?
    func delete(forKey key: String) throws
}

public final class InMemoryDatabaseClient: DatabaseClient {
    private var store: [String: Data] = [:]

    public init() {}

    public func save(_ data: Data, forKey key: String) throws {
        store[key] = data
    }

    public func load(forKey key: String) throws -> Data? {
        store[key]
    }

    public func delete(forKey key: String) throws {
        store[key] = nil
    }
}
