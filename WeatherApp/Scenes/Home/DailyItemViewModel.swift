import Foundation

struct DailyItemViewModel {
    let weekday: String
    let icon: String
    let minTemp: String
    let maxTemp: String
}

extension DailyItemViewModel {
    init(day: Weather.Day) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = .init(identifier: "en_US")
        self.weekday = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(day.datetimeEpoch)))
        self.icon = day.icon
        self.minTemp = String(Int(day.tempMin)) + "°"
        self.maxTemp = String(Int(day.tempMax)) + "°"
    }
}
