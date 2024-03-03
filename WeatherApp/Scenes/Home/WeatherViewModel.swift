import RxSwift
import RxCocoa
import CoreLocation

final class WeatherViewModel: NSObject {
    struct Input {
        let refresh: Driver<Void>
    }
    struct Output {
        let fetching: Driver<Bool>
        let location:  Driver<String>
        let items: Driver<[WeatherSection]>
        let error: Driver<Error>
    }
    private let bag = DisposeBag()
    private let useCase: WeatherUseCase
    
    init(useCase: WeatherUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let responce: Driver<Weather.Responce> = input.refresh.flatMapLatest { [unowned self] in
            useCase.weather()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        }
        let location = responce.map { $0.address }
        let items: Driver<[WeatherSection]> = responce.map {
            // Take hours in first two days if it exists
            var unfilteredHours = [Weather.Hour]()
            let hoursCount = $0.days.count <= 2 ? $0.days.count : 2
            for i in 0..<hoursCount {
                unfilteredHours += $0.days[i].hours
            }
            // Take 24 hours from current time
            let hours = unfilteredHours.filter {
                let hour = Calendar.current.component(.hour, from: Date())
                let currentDate = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
                // A date with 24h offset from currentDate
                let newDate = Calendar.current.date(byAdding: .hour, value: 24, to: currentDate) ?? Date()
                let currentEpoch = Int(currentDate.timeIntervalSince1970)
        
                let newEpoch = Int(newDate.timeIntervalSince1970)
                return currentEpoch <= $0.datetimeEpoch && $0.datetimeEpoch <= newEpoch
            }
            let selectedHour = ReplaySubject<HourlyItemViewModel>.create(bufferSize: 1)
            if (hours.count > 0) {
                selectedHour.onNext(HourlyItemViewModel(hour: hours[0]))
            }
            let hourlyItemsViewModel = HourlyItemsViewModel(items: Observable.just(hours.map { HourlyItemViewModel(hour: $0) }).asDriverOnErrorJustComplete(),
                                                            selectedItem: selectedHour,
                                                            refreshing: activityIndicator.asDriver())
            
            let sections: [WeatherSection] = [
                .selected(title: "Current", items: [.selectedItem(viewModel: selectedHour.asDriverOnErrorJustComplete())]),
                .hourly(title: "24 hours", items: [.hourlyItem(viewModel: hourlyItemsViewModel)]),
                .daily(title: "\($0.days.count) days", items: $0.days.map { WeatherSectionItem.dailyItem(viewModel: DailyItemViewModel(day: $0))})
            ]
            
            return sections
        }
        
        return Output(fetching: activityIndicator.asDriver(),
                      location: location.asDriver(),
                      items: items,
                      error: errorTracker.asDriver())
    }
    
}
