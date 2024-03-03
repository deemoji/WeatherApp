import RxCocoa
import RxDataSources

enum WeatherSection {
    case selected(title: String, items: [WeatherSectionItem])
    case hourly(title: String, items: [WeatherSectionItem])
    case daily(title: String, items: [WeatherSectionItem])
}

enum WeatherSectionItem {
    case selectedItem(viewModel: Driver<HourlyItemViewModel>)
    case hourlyItem(viewModel: HourlyItemsViewModel)
    case dailyItem(viewModel: DailyItemViewModel)
}

extension WeatherSection: SectionModelType {
    typealias Item = WeatherSectionItem
    
    var items: [WeatherSectionItem] {
        switch self {
        case .selected(_, let items):
            return items.map { $0 }
        case .hourly(_, let items):
            return items.map { $0 }
        case .daily(_, let items):
            return items.map { $0 }
        }
    }
    
    init(original: WeatherSection, items: [WeatherSectionItem]) {
        switch original {
        case let .selected(title, items):
            self = .selected(title: title, items: items)
        case let .hourly(title, items):
            self = .hourly(title: title, items: items)
        case let .daily(title, items):
            self = .daily(title: title, items: items)
        }
    }
}

extension WeatherSection {
    var title: String {
        switch self {
        case .selected(let title, _):
            return title
        case .hourly(let title, _):
            return title
        case .daily(let title, _):
            return title
        }
    }
}
