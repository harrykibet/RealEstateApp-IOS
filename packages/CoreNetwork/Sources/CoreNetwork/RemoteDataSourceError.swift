import Foundation

public enum RemoteDataSourceError: Error {
    case missingUserId
    case missingPropertyId
    case emptyResponse
}
