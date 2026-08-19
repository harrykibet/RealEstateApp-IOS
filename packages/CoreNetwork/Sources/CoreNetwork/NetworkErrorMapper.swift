import Foundation
import CoreCommon

public extension APIClient {
    // Async wrappers that map infra errors to domain errors using the given mapper.
    // Auth and network infra errors (that conform to the marker protocols) will be passed through unchanged.

    func getMapped(_ path: String, query: [URLQueryItem]? = nil, mapper: @escaping (Error) -> Error = { DefaultInfrastructureToDomainExceptionMapper.map($0) }) async throws -> Data {
        do {
            return try await get(path, query: query)
        } catch {
            throw mapper(error)
        }
    }

    func postMapped(_ path: String, body: Data?, mapper: @escaping (Error) -> Error = { DefaultInfrastructureToDomainExceptionMapper.map($0) }) async throws -> Data {
        do {
            return try await post(path, body: body)
        } catch {
            throw mapper(error)
        }
    }

    func putMapped(_ path: String, body: Data?, mapper: @escaping (Error) -> Error = { DefaultInfrastructureToDomainExceptionMapper.map($0) }) async throws -> Data {
        do {
            return try await put(path, body: body)
        } catch {
            throw mapper(error)
        }
    }

    func deleteMapped(_ path: String, mapper: @escaping (Error) -> Error = { DefaultInfrastructureToDomainExceptionMapper.map($0) }) async throws -> Data {
        do {
            return try await delete(path)
        } catch {
            throw mapper(error)
        }
    }
}
