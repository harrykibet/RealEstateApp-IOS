import Foundation

public protocol UseCase {
    associatedtype Output
    func execute() async throws -> Output
}

public protocol ParameterizedUseCase {
    associatedtype Input
    associatedtype Output
    func execute(_ input: Input) async throws -> Output
}
