import RxSwift
import RxCocoa

final class HourlyItemsViewModel {
    
    struct Input {
        let hourSelected: Driver<IndexPath>
    }
    struct Output {
        let hourlyWeather: Driver<[HourlyItemViewModel]>
        let refreshing: Driver<Bool>
    }
    
    private let items: Driver<[HourlyItemViewModel]>
    private let selectedItem: ReplaySubject<HourlyItemViewModel>
    private let refreshing: Driver<Bool>
    private let bag = DisposeBag()
    
    init(items: Driver<[HourlyItemViewModel]>, selectedItem: ReplaySubject<HourlyItemViewModel>, refreshing: Driver<Bool>) {
        self.items = items
        self.selectedItem = selectedItem
        self.refreshing = refreshing

    }
    func transform(_ input: Input) -> Output {
        input.hourSelected.withLatestFrom(items) { (indexPath, hourly) -> HourlyItemViewModel in
            return hourly[indexPath.item]
        }.drive { [unowned self] in
            selectedItem.onNext($0)
        }.disposed(by: bag)

        return Output(hourlyWeather: items, refreshing: refreshing)
    }
}
