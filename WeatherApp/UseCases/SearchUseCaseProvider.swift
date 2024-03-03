import Foundation

protocol SearchUseCaseProvider {
    func makeUseCase() -> SearchUseCase
}

final class DefaultSearchUseCaseProvider: SearchUseCaseProvider {
    func makeUseCase() -> SearchUseCase {
        MKSearchUseCase()
    }
}
