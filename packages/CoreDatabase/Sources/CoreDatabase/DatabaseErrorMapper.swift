import Foundation
import CoreCommon

public extension DatabaseClient {
    // Helper wrapper that maps thrown infrastructure errors to domain errors using provided mapper.
    // Default mapper preserves auth/network infra exceptions (per marker protocols) and maps others to DomainError.
    func saveMapped(_ data: Data, forKey key: String, mapper: (Error) -> Error = { DefaultInfrastructureToDomainExceptionMapper.map($0) }) throws {
        do {
            try save(data, forKey: key)
        } catch {
            throw mapper(error)
        }
    }

    func loadMapped(forKey key: String, mapper: (Error) -> Error = { DefaultInfrastructureToDomainExceptionMapper.map($0) }) throws -> Data? {
        do {
            return try load(forKey: key)
        } catch {
            throw mapper(error)
        }
    }

    func deleteMapped(forKey key: String, mapper: (Error) -> Error = { DefaultInfrastructureToDomainExceptionMapper.map($0) }) throws {
        do {
            try delete(forKey: key)
        } catch {
            throw mapper(error)
        }
    }
}
