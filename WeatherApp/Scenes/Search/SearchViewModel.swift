import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    struct Input {
        let searchText: Driver<String>
        let itemSelected: Driver<IndexPath>
    }
    struct Output {
        let items: Driver<[String]>
        let error: Driver<Error>
    }
    
    private let useCase: SearchUseCase
    private let navigator: SearchNavigator
    
    private let bag = DisposeBag()
    
    init(_ useCase: SearchUseCase, navigator: SearchNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let items: Driver<[String]> = input.searchText
            .throttle(.milliseconds(300))
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] query in
                if query.isEmpty {
                    return .just([])
                }
                return useCase
                    .search(with: query)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        input.itemSelected.withLatestFrom(items) { indexPath, cities in
            cities[indexPath.row]
        }.drive(onNext: { [weak self] in
            self?.navigator.toWeather(city: $0)
        }).disposed(by: bag)
        
        let error = errorTracker.asDriver()
        
        return Output(items: items, error: error)
    }
    
}
