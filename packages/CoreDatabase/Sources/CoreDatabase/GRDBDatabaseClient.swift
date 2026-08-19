import Foundation
import GRDB

/// A simple key-value table backed by GRDB. This implements the DatabaseClient protocol
/// and provides basic save/load/delete operations. It also exposes migration support.
public final class GRDBDatabaseClient: DatabaseClient {
    private let dbPool: DatabasePool

    /// Initialize with a file path for the sqlite database. Use ":memory:" for an in-memory DB.
    public init(path: String = "db.sqlite") throws {
        var config = Configuration()
        config.prepareDatabase { db in
            // enable foreign keys, WAL, etc. Customize as needed
            try db.execute(sql: "PRAGMA foreign_keys = ON;")
        }

        if path == ":memory:" {
            self.dbPool = try DatabasePool(path: ":memory:", configuration: config)
        } else {
            // Ensure directory exists
            let url = URL(fileURLWithPath: path)
            let dir = url.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            self.dbPool = try DatabasePool(path: path, configuration: config)
        }

        try migrator.migrate(dbPool)
    }

    // MARK: - Database schema and migrations
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        // Create simple key-value store
        migrator.registerMigration("createKV") { db in
            try db.create(table: "kv") { t in
                t.column("key", .text).primaryKey()
                t.column("value", .blob)
                t.column("created_at", .datetime).notNull().defaults(to: Date())
                t.column("updated_at", .datetime).notNull().defaults(to: Date())
            }
        }

        return migrator
    }

    // MARK: - CRUD
    public func save(_ data: Data, forKey key: String) throws {
        try dbPool.write { db in
            let now = Date()
            // Try update first
            let updated = try db.execute(sql: "UPDATE kv SET value = ?, updated_at = ? WHERE key = ?", arguments: [data, now, key])
            if db.changesCount == 0 {
                try db.execute(sql: "INSERT INTO kv (key, value, created_at, updated_at) VALUES (?, ?, ?, ?)", arguments: [key, data, now, now])
            }
        }
    }

    public func load(forKey key: String) throws -> Data? {
        try dbPool.read { db in
            let row = try Row.fetchOne(db, sql: "SELECT value FROM kv WHERE key = ?", arguments: [key])
            return row.flatMap { $0.dataNoCopy(named: "value") }
        }
    }

    public func delete(forKey key: String) throws {
        try dbPool.write { db in
            try db.execute(sql: "DELETE FROM kv WHERE key = ?", arguments: [key])
        }
    }
}
